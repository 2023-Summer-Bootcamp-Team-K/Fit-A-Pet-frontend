import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/model/user.dart';
import 'package:provider/provider.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController userageController = TextEditingController();
  final TextEditingController usersensorwearController =
      TextEditingController();
  String foodValue = '사료';
  String countValue = '인슐린 주사 일일 투여 횟수';
  String genderValue = '성별';
  String specieValue = '종';
  String supplementValue = '필요 영양제';
  String userImage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Pet Create'),
        backgroundColor: Color(0xFFC1CCFF),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Color(0xFFC1CCFF),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: () {
                      selectImage();
                    },
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: userImage.isNotEmpty
                            ? DecorationImage(
                                image: FileImage(File(userImage)),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: userImage.isNotEmpty
                          ? null
                          : Icon(Icons.camera_alt,
                              size: 60, color: Colors.grey[600]),
                    ),
                  ),
                ),
                SizedBox(height: 30),
                buildUsernameTextField(),
                SizedBox(height: 20),
                buildUserageTextField(),
                SizedBox(height: 20),
                buildUserfoodDropdown(),
                SizedBox(height: 20),
                buildUsercountDropdown(),
                SizedBox(height: 20),
                buildUsergenderDropdown(),
                SizedBox(height: 20),
                buildUserspecieDropdown(),
                SizedBox(height: 20),
                buildUsersupplementDropdown(),
                SizedBox(height: 20),
                buildUsersensorwearTextField(),
                SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
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
                    onPressed: saveUser,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUsernameTextField() => TextField(
        controller: usernameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: '이름',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  Widget buildUserageTextField() => TextField(
        controller: userageController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: '나이',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  Widget buildUserfoodDropdown() {
    final foodListData = [
      {"title": "돼지고기사료", "value": "1"},
      {"title": "소고기사료", "value": "2"},
      {"title": "닭고기사료", "value": "3"},
      {"title": "오리고기사료", "value": "4"},
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: foodValue.isEmpty ? null : foodValue,
      items: [
        DropdownMenuItem(
          child: Text(
            '사료',
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: '사료',
        ),
        ...foodListData.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        setState(() {
          foodValue = value!;
        });
      },
    );
  }

  Widget buildUsercountDropdown() {
    final countListData = [
      {"title": "1회", "value": "1"},
      {"title": "2회", "value": "2"},
      {"title": "3회", "value": "3"},
      {"title": "4회", "value": "4"},
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: countValue.isEmpty ? null : countValue,
      items: [
        DropdownMenuItem(
          child: Text(
            '인슐린 주사 일일 투여 횟수',
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: '인슐린 주사 일일 투여 횟수',
        ),
        ...countListData.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        setState(() {
          countValue = value!;
        });
      },
    );
  }

  Widget buildUsergenderDropdown() {
    final genderListData = [
      {"title": "남성", "value": "1"},
      {"title": "여성", "value": "2"},
      {"title": "중성", "value": "3"},
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: genderValue.isEmpty ? null : genderValue,
      items: [
        DropdownMenuItem(
          child: Text(
            '성별',
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: '성별',
        ),
        ...genderListData.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        setState(() {
          genderValue = value!;
        });
      },
    );
  }

  Widget buildUserspecieDropdown() {
    final specieListData = [
      //한국에서 인기있는 강아지 Top8
      {"title": "말티즈", "value": "1"},
      {"title": "푸들", "value": "2"},
      {"title": "포메라니안", "value": "3"},
      {"title": "믹스견", "value": "4"},
      {"title": "치와와", "value": "5"},
      {"title": "시츄", "value": "6"},
      {"title": "골든리트리버", "value": "7"},
      {"title": "진돗개", "value": "8"},
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: specieValue.isEmpty ? null : specieValue,
      items: [
        DropdownMenuItem(
          child: Text(
            '종',
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: '종',
        ),
        ...specieListData.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        setState(() {
          specieValue = value!;
        });
      },
    );
  }

  Widget buildUsersupplementDropdown() {
    final supplementListData = [
      //필요 영양제 5가지
      {"title": "관절영양제", "value": "1"},
      {"title": "피부영양제", "value": "2"},
      {"title": "기관지영양제", "value": "3"},
      {"title": "눈영양제", "value": "4"},
      {"title": "소화영양제", "value": "5"},
    ];

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: supplementValue.isEmpty ? null : supplementValue,
      items: [
        DropdownMenuItem(
          child: Text(
            '필요 영양제',
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: '필요 영양제',
        ),
        ...supplementListData.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        setState(() {
          supplementValue = value!;
        });
      },
    );
  }

  Widget buildUsersensorwearTextField() => TextField(
        controller: usersensorwearController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          hintText: '센서 착용 날짜',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  void selectImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        userImage = pickedFile.path;
      });
    }
  }

  void saveUser() {
    final state = Provider.of<User>(context, listen: false);
    state.username = usernameController.text;
    state.userage = userageController.text;
    state.userfood = getSelectedFoodTitle(foodValue);
    state.usercount = getSelectedCountTitle(countValue);
    state.usergender = getSelectedGenderTitle(genderValue);
    state.userspecie = getSelectedSpecieTitle(specieValue);
    state.usersupplement = getSelectedSupplementTitle(supplementValue);
    state.usersensorwear = usersensorwearController.text;
    state.userImage = userImage;

    Navigator.pop(
      context,
      Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                SizedBox(
                  width: 102,
                  height: 102,
                  child: CircleAvatar(
                    backgroundImage: state.userImage.isNotEmpty
                        ? FileImage(File(state.userImage))
                        : AssetImage("images/pet_basic.png")
                            as ImageProvider<Object>,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Text(
                        state.username,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(height: 13),
                      buildUserField('나이:', state.userage, fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('사료:', state.userfood, fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('인슐린 주사 일일 투여 횟수:', state.usercount,
                          fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('성별:', state.usergender, fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('종:', state.userspecie, fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('필요 영양제:', state.usersupplement,
                          fontSize: 13),
                      SizedBox(height: 13),
                      buildUserField('센서착용날짜:', state.usersensorwear,
                          fontSize: 13),
                      SizedBox(height: 13),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserField(String label, String value, {double fontSize = 20}) {
    return Row(
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        SizedBox(width: 8),
        Text(
          value ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ],
    );
  }

  String getSelectedFoodTitle(String value) {
    final foodListData = [
      {"title": "돼지고기사료", "value": "1"},
      {"title": "소고기사료", "value": "2"},
      {"title": "닭고기사료", "value": "3"},
      {"title": "오리고기사료", "value": "4"},
    ];

    final item = foodListData.firstWhere((item) => item['value'] == value);
    return item['title']!;
  }

  String getSelectedCountTitle(String value) {
    final countListData = [
      {"title": "1회", "value": "1"},
      {"title": "2회", "value": "2"},
      {"title": "3회", "value": "3"},
      {"title": "4회", "value": "4"},
    ];

    final item = countListData.firstWhere((item) => item['value'] == value);
    return item['title']!;
  }

  String getSelectedGenderTitle(String value) {
    final genderListData = [
      {"title": "남성", "value": "1"},
      {"title": "여성", "value": "2"},
      {"title": "중성", "value": "3"},
    ];

    final item = genderListData.firstWhere((item) => item['value'] == value);
    return item['title']!;
  }

  String getSelectedSpecieTitle(String value) {
    final specieListData = [
      //한국에서 인기있는 강아지 Top8
      {"title": "말티즈", "value": "1"},
      {"title": "푸들", "value": "2"},
      {"title": "포메라니안", "value": "3"},
      {"title": "믹스견", "value": "4"},
      {"title": "치와와", "value": "5"},
      {"title": "시츄", "value": "6"},
      {"title": "골든리트리버", "value": "7"},
      {"title": "진돗개", "value": "8"},
    ];

    final item = specieListData.firstWhere((item) => item['value'] == value);
    return item['title']!;
  }

  String getSelectedSupplementTitle(String value) {
    final supplementListData = [
      //필요 영양제 5가지
      {"title": "관절영양제", "value": "1"},
      {"title": "피부영양제", "value": "2"},
      {"title": "기관지영양제", "value": "3"},
      {"title": "눈영양제", "value": "4"},
      {"title": "소화영양제", "value": "5"},
    ];

    final item =
        supplementListData.firstWhere((item) => item['value'] == value);
    return item['title']!;
  }
}
