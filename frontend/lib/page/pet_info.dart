import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/user.dart';
import 'package:frontend/page/create_page.dart';
import 'package:frontend/page/edit_page.dart';

class Pet {
  final String name;
  final int age;
  final String? species;
  final String? gender;
  final double weight;
  final DateTime startedDate;
  final String? feed;
  final String? soreSpot;
  final File? profileImage;

  Pet({
    required this.name,
    required this.age,
    this.species,
    this.gender,
    required this.weight,
    required this.startedDate,
    this.feed,
    this.soreSpot,
    this.profileImage,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      name: json['name'],
      age: json['age'],
      species: json['species'],
      gender: json['gender'],
      weight: json['weight'],
      startedDate: DateTime.parse(json['started_date']),
      feed: json['feed'],
      soreSpot: json['sore_spot'],
    );
  }
}

class PetInfoPage extends StatefulWidget {
  @override
  _PetInfoPageState createState() => _PetInfoPageState();
}

class _PetInfoPageState extends State<PetInfoPage> {
  List<Pet> pets = []; // Pet 정보를 담을 리스트

  @override
  void initState() {
    super.initState();
    fetchPets(); // 앱이 시작될 때 Pet 정보를 가져오도록 초기화 시 호출합니다.
  }

  // Django의 GET API를 호출하여 Pet 정보를 가져오는 함수
  void fetchPets() async {
    final apiUrl = 'http://54.180.70.169/api/pets/list/2/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // API 호출이 성공한 경우
        final List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          pets = data.map((petJson) => Pet.fromJson(petJson)).toList();
        });
      } else {
        // API 호출이 실패한 경우
        print('Failed to fetch pets. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred while fetching pets: $e');
    }
  }

  // Pet 정보를 사용하여 Container를 생성하는 함수
  Container createPetContainer(Pet pet) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Align(
        alignment: Alignment.center, // Center the content within the container
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
                fetchPets(); // 재로딩 아이콘을 누를 때 Pet 정보를 다시 가져옵니다.
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                  // child: Container(
                  //   padding: EdgeInsets.all(16.0),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(16),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text(
                  //         'User Information',
                  //         style: TextStyle(
                  //           fontSize: 20,
                  //           fontWeight: FontWeight.bold,
                  //         ),
                  //       ),
                  //       // TODO: User 정보를 표시하는 부분을 작성하세요.
                  //     ],
                  //   ),
                  // ),
                  ),
              SizedBox(height: 20),
              // 컨테이너와 간격을 표시
              ...pets.map((pet) {
                return Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width *
                          0.9, // 컨테이너 너비를 전체 너비의 90%로 설정
                      child: Center(
                        // Center the container in the Column
                        child: Stack(
                          children: [
                            createPetContainer(pet),
                            Positioned(
                              top: 10,
                              right: 30,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    navigateToEditPage(context);
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

  void navigateToEditPage(BuildContext context) async {
    try {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EditPage()),
      );
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
