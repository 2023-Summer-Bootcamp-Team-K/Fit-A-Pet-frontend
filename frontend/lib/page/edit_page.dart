import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PetInfo {
  final String name;
  final int age;
  final String species;
  final String gender;
  final double weight;
  final DateTime startedDate;
  final String feed;
  final String soreSpot;
  final File? profileImage;

  PetInfo({
    required this.name,
    required this.age,
    required this.species,
    required this.gender,
    required this.weight,
    required this.startedDate,
    required this.feed,
    required this.soreSpot,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'age': age,
      'species': species,
      'gender': gender,
      'weight': weight,
      'started_date': startedDate.toIso8601String(),
      'feed': feed,
      'sore_spot': soreSpot,
    };

    if (profileImage != null) {
      data['profile_image'] = base64Encode(profileImage!.readAsBytesSync());
    }

    return data;
  }
}

class EditPage extends StatefulWidget {
  final int petId;
  final Map<String, dynamic> petData;

  EditPage({required this.petId, required this.petData});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
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

  String _selectedSpecies = '';
  String _selectedGender = '';
  String _selectedFeed = '';
  String _selectedSoreSpot = '';

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.petData['name'] ?? '';
    _ageController.text = widget.petData['age'].toString() ?? '';
    _weightController.text = widget.petData['weight'].toString() ?? '';
    _startedDateController.text = widget.petData['startedDate'] ?? '';

    _selectedSpecies = widget.petData['species'] ?? speciesOptions[0];
    _selectedGender = widget.petData['gender'] ?? genderOptions[0];
    _selectedFeed = widget.petData['feed'] ?? feedOptions[0];
    _selectedSoreSpot = widget.petData['soreSpot'] ?? soreSpotOptions[0];
  }

  Future<void> _pickImage() async {
    final ImagePicker _imagePicker = ImagePicker();
    final pickedImage = await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return Builder(
          builder: (BuildContext context) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Camera'),
                    onTap: () async {
                      await Future.delayed(
                          Duration(milliseconds: 500)); // 약간의 지연
                      final image = await _imagePicker.pickImage(
                          source: ImageSource.camera);
                      Navigator.pop(context, image); // 이미지 반환
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () async {
                      await Future.delayed(
                          Duration(milliseconds: 500)); // 약간의 지연
                      final image = await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                      Navigator.pop(context, image); // 이미지 반환
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (pickedImage != null && mounted) {
      setState(() {
        _pickedImage = File(pickedImage.path);
      });
    }
  }

  void _registerPet() async {
    final String apiUrl =
        'http://54.180.70.169/api/pets/modify/${widget.petId}/'; //modify/120/(petid=> 2번pet) //create/2/(userid=> 2번user) //list/3/(조회=userid) //delete/4/(삭제=petid)

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
      'species': petInfo.species,
      'gender': petInfo.gender,
      'weight': petInfo.weight.toString(),
      'started_date': petInfo.startedDate.toIso8601String(),
      'feed': petInfo.feed,
      'sore_spot': petInfo.soreSpot,
    };

    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('PATCH', uri) //POST, PATCH
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
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      print('Failed to modify pet. Status code: ${response.statusCode}');
    }
  }

  void _deletePet() async {
    final String apiUrl = //404 실패 , 204 성공
        'http://54.180.70.169/api/pets/delete/${widget.petId}/'; //modify/120/(petid=> 2번pet) //create/2/(userid=> 2번user) //list/3/(조회=userid) //delete/4/(삭제=petid)

    var uri = Uri.parse(apiUrl);
    var request = http.MultipartRequest('DELETE', uri);

    var response = await request.send();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
    } else {
      print('Failed to delete pet. Status code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Pet Modify'),
        backgroundColor: Color(0xFFC1CCFF),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: _deletePet,
          ),
        ],
      ),
      body: Container(
        color: Color(0xFFC1CCFF),
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
                    _selectedSpecies = newValue!;
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
                    _selectedGender = newValue!;
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
                    _selectedFeed = newValue!;
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
                    _selectedSoreSpot = newValue!;
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
                  "수정완료",
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
