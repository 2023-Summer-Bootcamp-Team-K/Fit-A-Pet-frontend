//하 여기부터 건들지ㅏ마ㅏ마
//제발
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';

class PetInfo {
  final String name;
  final int age;
  final String? species; // Nullable 타입으로 변경
  final String? gender; // Nullable 타입으로 변경
  final double weight;
  final DateTime startedDate;
  final String? feed; // Nullable 타입으로 변경
  final String? soreSpot; // Nullable 타입으로 변경
  final File? profileImage;

  PetInfo({
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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'age': age,
      'weight': weight,
      'started_date': startedDate.toIso8601String(),
    };

    if (species != null) {
      data['species'] = species;
    }

    if (gender != null) {
      data['gender'] = gender;
    }

    if (feed != null) {
      data['feed'] = feed;
    }

    if (soreSpot != null) {
      data['sore_spot'] = soreSpot;
    }

    if (profileImage != null) {
      data['profile_image'] = base64Encode(profileImage!.readAsBytesSync());
    }

    return data;
  }
}

class PetRegistrationPage extends StatefulWidget {
  @override
  _PetRegistrationPageState createState() => _PetRegistrationPageState();
}

class _PetRegistrationPageState extends State<PetRegistrationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _startedDateController = TextEditingController();

  File? _pickedImage;

  final List<String> speciesOptions = ["Dog", "Cat", "Bird"];
  final List<String> genderOptions = [
    "unspayed female",
    "spayed female",
    "neutered male",
    "unneutered male"
  ];
  final List<String> feedOptions = ["돼지고기사료", "소고기사료", "닭고기사료", "오리고기사료"];
  final List<String> soreSpotOptions = ["Back", "Legs", "Stomach"];

  String? _selectedSpecies; // Nullable 타입으로 변경
  String? _selectedGender; // Nullable 타입으로 변경
  String? _selectedFeed; // Nullable 타입으로 변경
  String? _selectedSoreSpot; // Nullable 타입으로 변경

  @override
  void initState() {
    super.initState();
    _selectedSpecies = null;
    _selectedGender = null;
    _selectedFeed = null;
    _selectedSoreSpot = null;
  }

  Future<void> _pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    final pickedImage = await showModalBottomSheet<PickedFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _imagePicker.pickImage(source: ImageSource.camera),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () async {
                  Navigator.pop(
                    context,
                    await _imagePicker.pickImage(source: ImageSource.gallery),
                  );
                },
              ),
            ],
          ),
        );
      },
    );

    setState(() {
      _pickedImage = pickedImage != null ? File(pickedImage.path) : null;
    });
  }

  void _registerPet() async {
    final String apiUrl = 'http://54.180.70.169/api/pets/create/2/';

    final PetInfo petInfo = PetInfo(
      name: _nameController.text,
      age: int.parse(_ageController.text),
      species: _selectedSpecies,
      gender: _selectedGender,
      weight: double.parse(_weightController.text),
      startedDate: DateTime.parse(_startedDateController.text),
      feed: _selectedFeed,
      soreSpot: _selectedSoreSpot,
      profileImage: _pickedImage,
    );

    final Map<String, String> requestBody = {
      'name': petInfo.name,
      'age': petInfo.age.toString(),
      'weight': petInfo.weight.toString(),
      'started_date': petInfo.startedDate.toIso8601String(),
    };

    if (petInfo.species != null) {
      requestBody['species'] = petInfo.species!;
    }

    if (petInfo.gender != null) {
      requestBody['gender'] = petInfo.gender!;
    }

    if (petInfo.feed != null) {
      requestBody['feed'] = petInfo.feed!;
    }

    if (petInfo.soreSpot != null) {
      requestBody['sore_spot'] = petInfo.soreSpot!;
    }

    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('POST', uri)
      ..fields.addAll(requestBody);

    if (petInfo.profileImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'profile_image',
          petInfo.profileImage!.path,
        ),
      );
    }

    var response = await request.send();
    if (response.statusCode == 201) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      print('Failed to register pet. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Pet Create'),
        backgroundColor: Color(0xFFC1CCFF),
      ),
      body: Container(
        color: Color(0xFFC1CCFF), // 배경 색상을 Color(0xFFC1CCFF)로 변경
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage != null
                      ? null
                      : Icon(Icons.camera_alt,
                          size: 60, color: Colors.grey[600]),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: '이름',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: '나이',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                ),
                value: _selectedSpecies,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSpecies = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '종',
                      style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                  ),
                  ...speciesOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                // decoration: InputDecoration(labelText: 'Species'), //라벨
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                ),
                value: _selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    _selectedGender = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '성별',
                      style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                  ),
                  ...genderOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                // decoration: InputDecoration(labelText: 'Gender'), //라벨
              ),
              SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: '몸무게',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _startedDateController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  hintText: '센서착용날짜',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                ),
                value: _selectedFeed,
                onChanged: (newValue) {
                  setState(() {
                    _selectedFeed = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '사료',
                      style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                  ),
                  ...feedOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                // decoration: InputDecoration(labelText: 'Feed'),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(10),
                ),
                value: _selectedSoreSpot,
                onChanged: (newValue) {
                  setState(() {
                    _selectedSoreSpot = newValue;
                  });
                },
                items: [
                  DropdownMenuItem<String>(
                    value: null,
                    child: Text(
                      '필요영양제',
                      style: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                    ),
                  ),
                  ...soreSpotOptions
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ],
                // decoration: InputDecoration(labelText: 'Sore Spot'),
              ),
              SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Color(0xFFECB5FF),
                  padding: EdgeInsets.all(10),
                ),
                child: Text(
                  "입력완료",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  _registerPet();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PetInfoPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
