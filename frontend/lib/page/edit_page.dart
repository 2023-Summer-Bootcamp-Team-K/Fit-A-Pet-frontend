import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/profile_pic.dart';
import 'package:frontend/model/user.dart';

class EditPage extends StatefulWidget {
  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  late TextEditingController usernameController;
  late TextEditingController userageController;
  late String userfood;
  late String usercount;
  late String usergender;
  late String usersupplement;
  late String userspecie;
  late TextEditingController usersensorwearController;

  List<Map<String, String>> foodListData = [
    {"title": "돼지고기사료", "value": "1"},
    {"title": "소고기사료", "value": "2"},
    {"title": "닭고기사료", "value": "3"},
    {"title": "오리고기사료", "value": "4"},
  ];

  List<Map<String, String>> countListData = [
    {"title": "1회", "value": "1"},
    {"title": "2회", "value": "2"},
    {"title": "3회", "value": "3"},
    {"title": "4회", "value": "4"},
  ];

  List<Map<String, String>> genderListData = [
    {"title": "남성", "value": "1"},
    {"title": "여성", "value": "2"},
    {"title": "중성", "value": "3"},
  ];

  List<Map<String, String>> speciesListData = [
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

  List<Map<String, String>> supplementListData = [
    //필요 영양제 5가지
    {"title": "관절영양제", "value": "1"},
    {"title": "피부영양제", "value": "2"},
    {"title": "기관지영양제", "value": "3"},
    {"title": "눈영양제", "value": "4"},
    {"title": "소화영양제", "value": "5"},
  ];

  String foodValue = "";
  String countValue = "";
  String genderValue = "";
  String specieValue = "";
  String supplementValue = "";

  @override
  void initState() {
    super.initState();

    final user = Provider.of<User>(context, listen: false);

    usernameController = TextEditingController(text: user.username);
    userageController = TextEditingController(text: user.userage);
    userfood = user.userfood;
    usercount = user.usercount;
    usergender = user.usergender;
    userspecie = user.userspecie;
    usersupplement = user.usersupplement;
    usersensorwearController = TextEditingController(text: user.usersensorwear);

    // Check if the value exists in the food list data, otherwise use the first item as the default value
    if (!foodListData.any((item) => item['value'] == userfood)) {
      userfood = foodListData.first['value']!;
    }

    // Check if the value exists in the count list data, otherwise use the first item as the default value
    if (!countListData.any((item) => item['value'] == usercount)) {
      usercount = countListData.first['value']!;
    }

    // Check if the value exists in the gender list data, otherwise use the first item as the default value
    if (!genderListData.any((item) => item['value'] == usergender)) {
      usergender = genderListData.first['value']!;
    }

    // Check if the value exists in the species list data, otherwise use the first item as the default value
    if (!speciesListData.any((item) => item['value'] == userspecie)) {
      userspecie = speciesListData.first['value']!;
    }

    // Check if the value exists in the supplement list data, otherwise use the first item as the default value
    if (!supplementListData.any((item) => item['value'] == usersupplement)) {
      usersupplement = supplementListData.first['value']!;
    }

    foodValue = userfood;
    countValue = usercount;
    genderValue = usergender;
    specieValue = userspecie;
    supplementValue = usersupplement;
  }

  @override
  void dispose() {
    usernameController.dispose();
    userageController.dispose();
    usersensorwearController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true, //중간배치
          elevation: 0, //앱바 밑에 그림자 없애기기
          title: Text('Pet Edit'),
          backgroundColor: Color(0xFFC1CCFF),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color(0xFFC1CCFF),
            padding: EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ProfilePic(key: UniqueKey()),
                SizedBox(height: 25),
                buildUsernameTextField(),
                const SizedBox(height: 20),
                buildUserageTextField(),
                const SizedBox(height: 20),
                buildUserfoodDropdown(),
                const SizedBox(height: 20),
                buildUsercountDropdown(),
                const SizedBox(height: 20),
                buildUsergenderDropdown(),
                const SizedBox(height: 20),
                buildUserspecieDropdown(),
                const SizedBox(height: 20),
                buildUsersupplementDropdown(),
                const SizedBox(height: 20),
                buildUsersensorwearTextField(), //센서착용날짜
                const SizedBox(height: 40),
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
                  onPressed: saveUser,
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('나가기'),
        content: Text('저장없이 페이지를 나갈 것 입니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('예'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  Widget buildUsernameTextField() => TextField(
        controller: usernameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          // labelText: '이름',
          hintText: '이름을 입력하시오',
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
          // labelText: '나이',
          hintText: '나이를 입력하시오',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  Widget buildUserfoodDropdown() {
    final uniqueFoodList = foodListData.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // labelText: '사료',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: foodValue.isEmpty ? null : foodValue,
      items: [
        DropdownMenuItem(
          child: Text(
            "사료",
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: "",
        ),
        ...uniqueFoodList.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        updateFoodValue(value!);
      },
    );
  }

  Widget buildUsercountDropdown() {
    final uniqueCountList = countListData.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // labelText: '인슐린 주사 일일 투여 횟수',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: countValue.isEmpty ? null : countValue,
      items: [
        DropdownMenuItem(
          child: Text(
            "인슐린 주사 일일 투여 횟수",
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: "",
        ),
        ...uniqueCountList.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        updateCountValue(value!);
      },
    );
  }

  Widget buildUsergenderDropdown() {
    final uniqueGenderList =
        genderListData.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // labelText: '성별',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: genderValue.isEmpty ? null : genderValue,
      items: [
        DropdownMenuItem(
          child: Text(
            "성별",
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: "",
        ),
        ...uniqueGenderList.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        updateGenderValue(value!);
      },
    );
  }

  Widget buildUserspecieDropdown() {
    final uniqueSpecieList =
        speciesListData.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // labelText: '종',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: specieValue.isEmpty ? null : specieValue,
      items: [
        DropdownMenuItem(
          child: Text(
            "종",
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: "",
        ),
        ...uniqueSpecieList.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        updateSpecieValue(value!);
      },
    );
  }

  Widget buildUsersupplementDropdown() {
    final uniqueSupplementList =
        supplementListData.toSet().toList(); // Remove duplicates

    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        // labelText: '영양제',
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(10),
      ),
      value: supplementValue.isEmpty ? null : supplementValue,
      items: [
        DropdownMenuItem(
          child: Text(
            "영양제",
            style: TextStyle(
              color: Color.fromARGB(255, 75, 75, 75),
            ),
          ),
          value: "",
        ),
        ...uniqueSupplementList.map<DropdownMenuItem<String>>((data) {
          return DropdownMenuItem(
            child: Text(data['title']!),
            value: data['value'],
          );
        }),
      ],
      onChanged: (String? value) {
        updateSupplementValue(value!);
      },
    );
  }

  Widget buildUsersensorwearTextField() => TextField(
        controller: usersensorwearController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          //labelText: '센서 착용 날짜',
          hintText: '센서 착용 날짜를 입력하시오',
          fillColor: Colors.white,
          filled: true,
          contentPadding: const EdgeInsets.all(10),
        ),
      );

  void updateFoodValue(String value) {
    setState(() {
      foodValue = value;
    });
  }

  void updateCountValue(String value) {
    setState(() {
      countValue = value;
    });
  }

  void updateGenderValue(String value) {
    setState(() {
      genderValue = value;
    });
  }

  void updateSpecieValue(String value) {
    setState(() {
      specieValue = value;
    });
  }

  void updateSupplementValue(String value) {
    setState(() {
      supplementValue = value;
    });
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
    Navigator.of(context).pop();
  }

  String getSelectedFoodTitle(String value) {
    if (value.isNotEmpty) {
      final selectedFood = foodListData.firstWhere(
        (food) => food['value'] == value,
        orElse: () => {"title": ""},
      );
      return selectedFood['title']!;
    } else {
      return "";
    }
  }

  String getSelectedCountTitle(String value) {
    if (value.isNotEmpty) {
      final selectedCount = countListData.firstWhere(
        (count) => count['value'] == value,
        orElse: () => {"title": ""},
      );
      return selectedCount['title']!;
    } else {
      return "";
    }
  }

  String getSelectedGenderTitle(String value) {
    if (value.isNotEmpty) {
      final selectedGender = genderListData.firstWhere(
        (gender) => gender['value'] == value,
        orElse: () => {"title": ""},
      );
      return selectedGender['title']!;
    } else {
      return "";
    }
  }

  String getSelectedSpecieTitle(String value) {
    if (value.isNotEmpty) {
      final selectedSpecie = speciesListData.firstWhere(
        (specie) => specie['value'] == value,
        orElse: () => {"title": ""},
      );
      return selectedSpecie['title']!;
    } else {
      return "";
    }
  }

  String getSelectedSupplementTitle(String value) {
    if (value.isNotEmpty) {
      final selectedSupplement = supplementListData.firstWhere(
        (supplement) => supplement['value'] == value,
        orElse: () => {"title": ""},
      );
      return selectedSupplement['title']!;
    } else {
      return "";
    }
  }
}
//성능 개선X