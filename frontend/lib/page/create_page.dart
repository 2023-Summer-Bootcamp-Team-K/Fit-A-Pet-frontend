import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:date_format/date_format.dart'; //flutter pub get //추가
import 'package:syncfusion_flutter_datepicker/datepicker.dart'; //추가

class PetInfo {
  final String name;
  final int age;
  final String? species;
  final String? gender;
  final double weight;
  final DateTime startedDate;
  final String? feed;
  final String? soreSpot;
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

  final List<String> speciesOptions = [
    "말티즈",
    "푸들",
    "포메라니안",
    "믹스견",
    "치와와",
    "시츄",
    "골든리트리버",
    "진돗개"
  ];
  final List<String> genderOptions = ["수컷", "암컷", "중성화된 수컷", "중성화된 암컷"];
  final List<String> feedOptions = ["돼지고기 사료", "소고기 사료", "닭고기 사료", "오리고기 사료"];
  final List<String> soreSpotOptions = ["관절", "피부", "눈", "기관지", "소화"];

  String? _selectedSpecies;
  String? _selectedGender;
  String? _selectedFeed;
  String? _selectedSoreSpot;

//DatePicker //여기까지
  Future<void> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now().toLocal();

    if (_startedDateController.text.isNotEmpty) {
      List<String> dateParts = _startedDateController.text.split('-');
      if (dateParts.length == 3) {
        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);
        initialDate = DateTime(year, month, day).toLocal();
      }
    }

    DateTime? selectedDate;
    final SfDateRangePicker picker = SfDateRangePicker(
      initialSelectedDate: initialDate,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is DateTime) {
          selectedDate = args.value;
        }
      },
      startRangeSelectionColor: kPrimaryColor,
      endRangeSelectionColor: kPrimaryColor,
      rangeSelectionColor: Color.fromARGB(100, 135, 153, 239),
      selectionTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      todayHighlightColor: kPrimaryColor,
      selectionColor: kPrimaryColor,
      minDate: DateTime(2022),
      maxDate: DateTime.now(),
      selectionMode: DateRangePickerSelectionMode.single,
      headerStyle: const DateRangePickerHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF878CEF), // 헤더 폰트
          fontSize: 24,
        ),
      ),
      monthCellStyle: DateRangePickerMonthCellStyle(
        todayTextStyle: TextStyle(
          color: Color(0xFF878CEF), // 오늘 날짜의 폰트 색상
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.45,
          child: picker,
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF878CEF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
            ),
            onPressed: () {
              if (selectedDate != null) {
                setState(() {
                  _startedDateController.text = formatDate(
                    selectedDate!,
                    [yyyy, '-', mm, '-', dd],
                  );
                });
              }
              Navigator.pop(context);
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_pickedImage != null && !mounted) {
      setState(() {
        _pickedImage = null;
      });
    }
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
        'http://54.180.70.169/api/pets/create/1/'; //54.180.70.169

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
        title: Text(
          '반려동물 추가',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: Container(
        color: kPrimaryColor,
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
                    color:
                        Color.fromARGB(255, 248, 245, 250), //Colors.grey[300]
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _pickedImage != null
                      ? null
                      : Icon(
                          Icons.camera_alt,
                          size: 60,
                          color: Color(0xFF878CEF),
                        ), //color: Color(0xFF878CEF), //Colors.grey[600]
                ),
              ),
              SizedBox(height: 35),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
              ),
              SizedBox(height: 16),
              TextField(
                controller: _weightController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
                  ),
                  hintText: '몸무게',
                  fillColor: Colors.white,
                  filled: true,
                  contentPadding: const EdgeInsets.all(10),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: () => _selectDate(context), // Date picker 호출
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: _startedDateController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      hintText: '센서 착용 날짜',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: const EdgeInsets.all(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
                  focusedBorder: OutlineInputBorder(
                    // 클릭했을 때의 테두리 색상 설정
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                        color: Color(0xFF878CEF), width: 2.0), // 보라색 테두리
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
                      '불편한 부위',
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
                  backgroundColor: Color.fromARGB(255, 135, 153, 239),
                  padding: EdgeInsets.all(10),
                ),
                child: Text(
                  "입력 완료",
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
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
