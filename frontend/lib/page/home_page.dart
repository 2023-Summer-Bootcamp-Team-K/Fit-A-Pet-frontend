import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:frontend/main.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/edit_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Scaffold(
      backgroundColor: Color(0xFFC1CCFF),
      appBar: AppBar(
        centerTitle: true, //중간배치
        // elevation: 0, //앱바 밑에 그림자 없애기기
        title: Text("Fit-A-Pet"),
        backgroundColor: Color(0xFFC1CCFF),
      ),
      body: Column(
        children: [
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin:
                  EdgeInsets.fromLTRB(42, 0, 36, 19), //바깥쪽 //(왼쪽, 위, 오른쪽, 밑)
              padding: EdgeInsets.fromLTRB(15, 15, 15, 15), //안쪽
              // width: double.infinity,
              // height: 253, //223->253 (흰색박스 높이가 더 길어짐)
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //나이, 사료, 인슐린 주사 일일 투여횟수, 성별, 종, 필요영양제, 센서착용날짜 글자크기 조금 줄여주고, 왼쪽 정렬해줘.
                children: <Widget>[
                  //여기 안에 강아지 넣기 //sizedbox
                  SizedBox(
                    width: 102,
                    height: 102,
                    child: CircleAvatar(
                      backgroundImage: AssetImage("images/pet_basic.png"),
                    ),
                  ),
                  buildUserField('', user.username),
                  SizedBox(height: 20),
                  buildUserField('나이:', user.userage, fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('사료:', user.userfood, fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('인슐린 주사 일일 투여 횟수:', user.usercount,
                      fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('성별:', user.usergender, fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('종:', user.userspecie, fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('필요 영양제:', user.usersupplement, fontSize: 15),
                  SizedBox(height: 16),
                  buildUserField('센서착용날짜:', user.usersensorwear, fontSize: 15),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                backgroundColor: Color(0xFFECB5FF),
              ),
              icon: Icon(Icons.edit),
              label: Text(
                '수정하기',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                navigateToEditPage(context);
              },
            ),
          ),
        ],
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

  Widget buildUserField(String label, String value, {double fontSize = 20}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        const SizedBox(width: 8),
        Text(
          value ?? '',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
      ],
    );
  }
}
