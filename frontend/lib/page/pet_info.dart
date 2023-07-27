import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/create_page.dart';
import 'package:frontend/page/edit_page.dart';

class Pet {
  final int id;
  final String name;
  final int age;
  final String? species;
  final String? gender;
  final double weight;
  final DateTime startedDate;
  final String? feed;
  final String? soreSpot;
  final String? profileImageUrl;
  bool isChecked; // 체크박스 상태를 저장하는 변수

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
    this.isChecked = false, // 체크박스 상태를 기본적으로 선택되지 않은 상태로 초기화
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
      isChecked: false, // 체크박스 상태를 기본적으로 선택되지 않은 상태로 초기화
    );
  }
}

class PetInfoPage extends StatefulWidget {
  @override
  _PetInfoPageState createState() => _PetInfoPageState();
}

class _PetInfoPageState extends State<PetInfoPage> {
  bool isChecked = false; // 체크 상태를 관리하는 변수
  List<Pet> pets = [];
  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  void fetchPets() async {
    final apiUrl = 'http://54.180.70.169/api/pets/list/1/';
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

  void onPetCheckboxChanged(Pet selectedPet) {
    setState(() {
      // 선택된 펫 이외의 모든 펫의 체크박스를 해제합니다.
      pets.forEach((pet) {
        if (pet != selectedPet) {
          pet.isChecked = false;
        }
      });
      // 선택된 펫의 체크박스를 토글합니다.
      selectedPet.isChecked = !selectedPet.isChecked;
    });
  }

  Widget createPetContainer(Pet pet, User user) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // Apply purple border if the pet is checked
        border: pet.isChecked
            ? Border.all(color: Color.fromARGB(255, 135, 153, 239), width: 2)
            : null,
      ),
      child: Row(
        children: [
          // Left side - Pet Profile Image
          SizedBox(
            width: 102,
            height: 102,
            child: ClipOval(
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
                Text('나이: ${pet.age}살'),
                Text('종: ${pet.species ?? 'Unknown'}'),
                Text('성별: ${pet.gender ?? 'Unknown'}'),
                Text('몸무게: ${pet.weight}kg'),
                Text(
                    '센서착용날짜: ${pet.startedDate.toLocal().year}-${pet.startedDate.toLocal().month.toString().padLeft(2, '0')}-${pet.startedDate.toLocal().day.toString().padLeft(2, '0')}'),
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
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFFC1CCFF),
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text("반려동물 정보", style: TextStyle(fontWeight: FontWeight.bold)),
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
              SizedBox(height: 0),
              Center(
                child: Column(
                  children: pets.map((pet) {
                    return Column(
                      children: [
                        SizedBox(height: 20),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Center(
                            child: Stack(
                              children: [
                                // Pet Container
                                createPetContainer(pet, user),
                                // White Checkbox Container
                                Positioned(
                                  top: 10,
                                  left:
                                      10, // Adjust the left value to move it to the left
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    child: Checkbox(
                                      value: pet.isChecked,
                                      onChanged: (bool? value) {
                                        if (value == true && !pet.isChecked) {
                                          // 새로 선택된 경우에만 동작하도록 변경
                                          setState(() {
                                            onPetCheckboxChanged(
                                                pet); // 라디오 버튼처럼 선택 동작 처리
                                          });
                                        }
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      checkColor: Colors.white,
                                      activeColor: Color(0xFFC1CCFF),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.padded,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 15,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 20,
                                    child: IconButton(
                                      icon:
                                          Icon(Icons.edit, color: Colors.black),
                                      onPressed: () {
                                        navigateToEditPage(context, pet);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 35),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToCreatePage(context);
          },
          child: Icon(Icons.add),
          backgroundColor: Color.fromARGB(255, 135, 153, 239),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  int checkedCount = 0; // 선택된 체크박스 개수를 저장하는 변수

  void navigateToEditPage(BuildContext context, Pet pet) async {
    // 이전 코드: await Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(petId: pet.id)));

    // 서버에서 pet 정보를 가져오기 위한 API 호출
    final apiUrl = 'http://54.180.70.169/api/pets/detail/${pet.id}';
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // API 호출이 성공하면 가져온 데이터를 사용하여 EditPage로 이동
      final Map<String, dynamic> petData =
          json.decode(utf8.decode(response.bodyBytes));

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EditPage(
            petId: pet.id,
            petData: petData,
          ),
        ),
      );
    } else {
      print('Failed to fetch pet details. Status code: ${response.statusCode}');
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
