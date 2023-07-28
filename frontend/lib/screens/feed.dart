import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Feed_Page extends StatefulWidget {
  final String petID;

  Feed_Page({required this.petID});

  @override
  _Feed_PageState createState() => _Feed_PageState();
}

class _Feed_PageState extends State<Feed_Page> {
  List<String> feedDescriptions = [];

  String meatName = '';
  String meatDescription = '';
  String meatImageUrl = '';

  String oilName = '';
  String oilDescription = '';
  String oilImageUrl = '';

  String supplementName = '';
  String supplementDescription = '';
  String supplementImageUrl = '';

  String petName = '';
  int petAge = 0;
  double petWeight = 0;
  String feed = '';
  String soreSpot = '';

  @override
  void initState() {
    super.initState();
    fetchFeedData();
    fetchPetData(widget.petID);
  }

  void fetchFeedData() async {
    String apiUrl = 'http://54.180.70.169/api/feeds/10/';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        if (responseData['code'] == 200) {
          setState(() {
            var resultData = responseData['result'];

            var meatData = resultData['meat'];
            meatName = meatData['name'];
            meatDescription = meatData['description'];
            meatImageUrl = meatData['image_url'];

            var oilData = resultData['oil'];
            oilName = oilData['name'];
            oilDescription = oilData['description'];
            oilImageUrl = oilData['image_url'];

            var supplementData = resultData['supplement'];
            supplementName = supplementData['name'];
            supplementDescription = supplementData['description'];
            supplementImageUrl = supplementData['image_url'];

            if (resultData['description'] != null) {
              feedDescriptions = List.from(resultData['description']);
            }
          });
        } else {
          print('사료 조합이 없습니다.');
        }
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('반려동물 데이터 전송 중 오류 발생: $e');
    }
  }

  void fetchPetData(String petID) async {
    String apiUrlForPet = 'http://54.180.70.169/api/pets/detail/10/';

    try {
      final response = await http.get(
        Uri.parse(apiUrlForPet),
        headers: {
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(utf8.decode(response.bodyBytes));

        setState(() {
          petName = responseData['name'] ?? '';
          petAge = responseData['age'] ?? 0;
          petWeight = responseData['weight'] ?? 0.0;
          feed = responseData['feed'] ?? '';
          soreSpot = responseData['sore_spot'] ?? '';
        });
      } else {
        print('서버 오류: ${response.statusCode}');
      }
    } catch (e) {
      print('반려동물 데이터 전송 중 오류 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kPrimaryColor,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "사료 추천",
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Color(0xFFF86A1FF),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => HomeScreen(),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
              ),
            );
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: double.infinity,
              height: screenWidth * 0.4,
              decoration: BoxDecoration(
                color: Color(0xFFF86A1FF),
              ),
            ),
          ),
          Positioned(
            top: screenHeight*0.005,
            left: screenWidth*0,
            right: screenWidth*0,
            child: Container(
              width: double.infinity,
              height: screenHeight * 0.38,
              child: CustomPaint(
                painter: MyOvalPainter(), // MyOvalPainter는 아래에서 정의할 커스텀 페인터입니다.
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.004,
            right: screenWidth * 0.06,
            child: Center(
              child: Text(
                '# $petName\n# 키워드',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0,
            left: screenWidth * 0,
            width: screenWidth * 0.5,
            height: screenWidth * 0.5,
            child: Image.asset(
              'images/feedpage.png',
            ),
          ),
          Positioned(
            top: screenHeight * 0.11,
            right: screenWidth * 0.17,
            child: Stack(
              children: [
                Container(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' # $petAge세',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          ' # ${petWeight.toStringAsFixed(1)} kg',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          ' # $feed',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 7),
                        Text(
                          ' # 민감한 $soreSpot',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.31,
            left: screenWidth * 0.12,
            child: Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'meat',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(119, 131, 143, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.31,
            left: screenWidth * 0.43,
            child: Container(
              width: screenWidth * 0.15,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'oil',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(119, 131, 143, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.31,
            left: screenWidth * 0.69,
            child: Container(
              width: screenWidth * 0.25,
              height: screenWidth * 0.06,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'supplement',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(119, 131, 143, 1.0),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.06,
            child: Container(
              width: screenWidth * 0.27,
              height: screenWidth * 0.27,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: meatImageUrl.isNotEmpty
                  ? Center(
                      child: Image.network(
                        meatImageUrl,
                        width: screenWidth * 0.22,
                        height: screenWidth * 0.22,
                        fit: BoxFit.cover, // 이미지가 Container에 맞게 크기 조정됩니다.
                      ),
                    )
                  : Center(
                      child: Text(
                        '이미지를 불러올 수 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.37,
            child: Container(
              width: screenWidth * 0.27,
              height: screenWidth * 0.27,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: oilImageUrl.isNotEmpty
                  ? Image.network(
                      oilImageUrl,
                      width: screenWidth / 5,
                      height: screenWidth / 5,
                    )
                  : Center(
                      child: Text(
                        '이미지를 불러올 수 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: screenWidth * 0.68,
            child: Container(
              width: screenWidth * 0.27,
              height: screenWidth * 0.27,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: supplementImageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.network(
                        supplementImageUrl,
                        width: screenWidth *
                            0.27, // 이미지를 Container의 가로 크기와 일치시킵니다.
                        height: screenWidth *
                            0.27, // 이미지를 Container의 세로 크기와 일치시킵니다.
                        fit: BoxFit.cover, // 이미지가 Container에 맞게 크기 조정됩니다.
                      ),
                    )
                  : Center(
                      child: Text(
                        '이미지를 불러올 수 없습니다.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.5,
            left: screenWidth * 0.05,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              width: screenWidth * 0.9,
              height: screenHeight * 0.235,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0), // 행간을 넓혀줍니다.
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• meat - $meatDescription',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 131, 143, 1.0),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10), // 행간을 넓혀줍니다.
                    Text(
                      '• oil - $oilDescription',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 131, 143, 1.0),
                        fontSize: 17,
                      ),
                    ),
                    SizedBox(height: 10), // 행간을 넓혀줍니다.
                    Text(
                      '• supplement - $supplementDescription',
                      style: TextStyle(
                        color: Color.fromRGBO(119, 131, 143, 1.0),
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight*0.055,
            right: screenWidth*0.05,
            child: InkWell(
              onTap: _launchURL, // 버튼을 눌렀을 때 호출될 함수를 여기에 지정합니다.
              child: Container(
                width: screenWidth * 0.43,
                height: screenWidth * 0.14,
                decoration: BoxDecoration(
                  color: Color(0xFFF86A1FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        CupertinoIcons.chat_bubble_2,
                        color: Colors.white,
                      ),
                      SizedBox(width: 8), // Space between icon and text
                      Text(
                        '수의사님과 상담하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight*0.055,
            left: screenWidth * 0.054,
            child: InkWell(
              onTap: () {
                _showFeedbackDialog(context); // 클릭 시 피드백 다이얼로그를 띄웁니다.
              },
              child: Container(
                width: screenWidth * 0.43,
                height: screenWidth * 0.14,
                decoration: BoxDecoration(
                  color: Color(0xFFF86A1FF),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16),
                        child: Icon(
                          CupertinoIcons.paperplane,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 1),
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(
                                right: 8), // 이 부분을 조절하여 텍스트를 왼쪽으로 옮깁니다.
                            child: Text(
                              '피드백 보내기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _launchURL() async {
    const url = 'https://open.kakao.com/o/sOmd7Zuf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class FeedbackDialog extends StatefulWidget {
  @override
  _FeedbackDialogState createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  TextEditingController _feedbackController = TextEditingController();

  final BorderRadius _textFieldBorderRadius = BorderRadius.circular(8.0);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: kPrimaryColor,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: 5),
                Icon(
                  CupertinoIcons.paperplane,
                  color: Colors.white,
                ),
                Text(
                  ' 피드백 보내기',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: _textFieldBorderRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 3,
                      spreadRadius: 1,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _feedbackController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '사료 추천에 대한 피드백을 작성해주세요.',
                    hintStyle: TextStyle(color: Color.fromARGB(255, 119, 131, 143)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: _textFieldBorderRadius,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: _textFieldBorderRadius,
                    ),
                  ),
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    _submitFeedback();
                  },
                  child: Text(
                    '등록하기',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(width: 8.0),
                TextButton(
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    '취소',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _submitFeedback() async {
    String feedbackText = _feedbackController.text;
    String apiUrl =
        'http://54.180.70.169/api/suggestions/1/'; // API 엔드포인트를 여기에 입력하세요.

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contents': feedbackText,
        }),
      );

      if (response.statusCode == 201) {
        print('피드백이 성공적으로 저장되었습니다: $feedbackText');
        Navigator.of(context).pop(); // 다이얼로그를 닫습니다.
      } else {
        print('피드백 저장 실패: ${response.statusCode}');
      }
    } catch (e) {
      print('피드백 저장 중 오류 발생: $e');
    }
  }
}

void _showFeedbackDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return FeedbackDialog();
    },
  );
}

class MyOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Color(0xFFF86A1FF) // 타원의 색상을 여기서 지정
      ..style = PaintingStyle.fill;

    double centerX = size.width / 2;
    double centerY = size.height / 2;
    double radiusX = size.width; // 타원의 가로 반지름
    double radiusY = size.height * 0.5; // 타원의 세로 반지름

    canvas.drawOval(
        Rect.fromCenter(
            center: Offset(centerX, centerY), width: radiusX, height: radiusY),
        paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
