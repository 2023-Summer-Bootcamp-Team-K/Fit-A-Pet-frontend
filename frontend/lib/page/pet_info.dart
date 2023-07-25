import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user.dart';
import 'package:frontend/page/create_page.dart';
import 'package:frontend/page/edit_page.dart';

class Pet {
  final int id; // Adding id field
  final String name;
  final int age;
  final String? species;
  final String? gender;
  final double weight;
  final DateTime startedDate;
  final String? feed;
  final String? soreSpot;
  final String? profileImageUrl;

  Pet({
    required this.id,
    required this.name,
    required this.age,
    this.species,
    this.gender,
    required this.weight,
    required this.startedDate,
    this.feed,
    this.soreSpot,
    this.profileImageUrl,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      age: json['age'],
      species: json['species'],
      gender: json['gender'],
      weight: json['weight'],
      startedDate: DateTime.parse(json['started_date']),
      feed: json['feed'],
      soreSpot: json['sore_spot'],
      profileImageUrl: json['profile_url'],
    );
  }
}

class PetInfoPage extends StatefulWidget {
  @override
  _PetInfoPageState createState() => _PetInfoPageState();
}

class _PetInfoPageState extends State<PetInfoPage> {
  List<Pet> pets = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  void fetchPets() async {
    final apiUrl = 'http://54.180.70.169/api/pets/list/2/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          pets = data.map((petJson) => Pet.fromJson(petJson)).toList();
        });
      } else {
        print('Failed to fetch pets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while fetching pets: $e');
    }
  }

  Container createPetContainer(Pet pet, User user) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Left side - Pet Profile Image
          SizedBox(
            width: 102,
            height: 102,
            child: pet.profileImageUrl != null &&
                    pet.profileImageUrl!.trim().isNotEmpty
                ? Image.network(
                    pet.profileImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print("Error loading image: $error");
                      return Image.asset("images/pet_basic.png",
                          fit: BoxFit.cover);
                    },
                  )
                : Image.asset(
                    "images/pet_basic.png",
                    fit: BoxFit.cover,
                  ),
          ),

          SizedBox(width: 16),

          // Right side - Pet Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${pet.name}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('나이: ${pet.age}'),
                Text('종: ${pet.species ?? 'Unknown'}'),
                Text('성별: ${pet.gender ?? 'Unknown'}'),
                Text('몸무게: ${pet.weight}'),
                Text('센서착용날짜: ${pet.startedDate.toLocal()}'),
                Text('사료: ${pet.feed ?? 'Unknown'}'),
                Text('필요영양제: ${pet.soreSpot ?? 'Unknown'}'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFFC1CCFF),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("Fit-A-Pet"),
          backgroundColor: Color(0xFFC1CCFF),
          actions: [
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                fetchPets();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(),
              // 컨테이너와 간격을 표시
              ...pets.map((pet) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Center(
                        child: Stack(
                          children: [
                            createPetContainer(pet, user),
                            Positioned(
                              top: 10,
                              right: 30,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    navigateToEditPage(context, pet.id);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToCreatePage(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Color(0xFFECB5FF),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void navigateToEditPage(BuildContext context, int petID) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPage(petID: petID)),
      );
      // TODO: 수정이 완료된 후 pets 정보를 갱신해야 할 수도 있습니다.
      // 이 부분은 해당 페이지의 전체 상황에 따라서 구현해야 합니다.
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    }
  }

  void navigateToCreatePage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PetRegistrationPage()),
    );

    if (result != null) {
      setState(() {
        final container = result as Container;
        // TODO: 새로운 컨테이너를 pets 리스트에 추가하는 코드를 작성하세요.
        // (container를 사용하여 Pet 모델 객체를 만들어서 pets 리스트에 추가해야 합니다.)
      });
    }
  }
}
