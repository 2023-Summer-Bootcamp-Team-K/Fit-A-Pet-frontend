import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:date_format/date_format.dart'; //flutter pub get
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

//여기서부터//지우지마
//제발
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

  String _selectedSpecies = '';
  String _selectedGender = '';
  String _selectedFeed = '';
  String _selectedSoreSpot = '';

  String? _profileImageUrl;
  bool _isNoButtonPressed = false;
  bool _isYesButtonPressed = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
    _nameController.text = widget.petData['name'] ?? '';
    _ageController.text = widget.petData['age'].toString() ?? '';
    _weightController.text = widget.petData['weight'].toString() ?? '';
    DateTime parsedDate =
        DateTime.parse(widget.petData['started_date']).toLocal();
    _startedDateController.text =
        formatDate(parsedDate, [yyyy, '-', mm, '-', dd]);

    _selectedSpecies = widget.petData['species'] ?? speciesOptions[0];
    _selectedGender = widget.petData['gender'] ?? genderOptions[0];
    _selectedFeed = widget.petData['feed'] ?? feedOptions[0];
    _selectedSoreSpot = widget.petData['soreSpot'] ?? soreSpotOptions[0];

    _profileImageUrl = widget.petData['profile_url'];
  }

  Future<void> _deletePetConfirmation(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                Icons.error,
                color: Color(0xFF878CEF),
              ),
              SizedBox(width: 8),
              Text('펫 정보 삭제'),
            ],
          ),
          content: Text('정말 삭제하시겠습니까?'),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isYesButtonPressed
                            ? Color(0xFFC1CCFF).withAlpha(128) //'예'버튼 눌렀을때
                            : Colors.white, //'예'버튼 안눌렀을때
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          '예',
                          style: TextStyle(
                            color: Color(0xFF878CEF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PetInfoPage()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isNoButtonPressed
                            ? Color(0xFFC1CCFF).withAlpha(128) //'아니오'버튼 눌렀을때
                            : Colors.white, //'아니오'버튼 안눌렀을때
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          '아니요',
                          style: TextStyle(
                            color: Color(0xFF878CEF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isNoButtonPressed = !_isNoButtonPressed;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        _isYesButtonPressed = false;
        _isNoButtonPressed = false;
      });
    });
  }

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
      startRangeSelectionColor: Color(0xFFC1CCFF),
      endRangeSelectionColor: Color(0xFFC1CCFF),
      rangeSelectionColor: Color.fromARGB(100, 135, 153, 239),
      selectionTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      todayHighlightColor: Color(0xFFC1CCFF),
      selectionColor: Color(0xFFC1CCFF),
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
                      await Future.delayed(Duration(milliseconds: 500));
                      final image = await _imagePicker.pickImage(
                          source: ImageSource.camera);
                      Navigator.pop(context, image);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Gallery'),
                    onTap: () async {
                      await Future.delayed(Duration(milliseconds: 500));
                      final image = await _imagePicker.pickImage(
                          source: ImageSource.gallery);
                      Navigator.pop(context, image);
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
        title: Text(
          '반려동물 정보 수정',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFFC1CCFF),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              color: Colors.white,
            ),
            onPressed: () => _deletePetConfirmation(context),
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
                    color:
                        Color.fromARGB(255, 248, 245, 250), //Colors.grey[300]
                    image: _pickedImage != null
                        ? DecorationImage(
                            image: FileImage(_pickedImage!),
                            fit: BoxFit.cover,
                          )
                        : (_profileImageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_profileImageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null),
                  ),
                  child: _pickedImage != null
                      ? null
                      : (_profileImageUrl != null
                          ? null
                          : Icon(
                              Icons.camera_alt,
                              size: 60,
                              color: Color(0xFF878CEF),
                            )), //카메라 아이콘 //Color(0xFF878CEF)
                ),
              ),
              SizedBox(height: 35),
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
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextField(
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
                  "수정하기",
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
