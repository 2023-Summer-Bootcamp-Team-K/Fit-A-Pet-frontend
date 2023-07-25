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
    String apiUrl = 'http://54.180.70.169/api/feeds/99/';

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
    String apiUrlForPet = 'http://54.180.70.169/api/pets/detail/99/';

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
                // borderRadius: BorderRadius.only(
                //   bottomRight: Radius.circular(screenWidth * 0.2),
                //   bottomLeft: Radius.circular(screenWidth * 0.2),
                //   // topRight: Radius.circular(screenWidth * 0.5),
                //   // topLeft: Radius.circular(screenWidth * 0.5),
                // ),
              ),
            ),
          ),
          Positioned(
            top: 0.4,
            left: 0,
            right: 0,
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
            right: screenWidth * 0.09,
            child: Center(
              child: Text(
                '# $petName\n# 키워드',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  // fontWeight: FontWeight.bold,
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
            top: screenHeight * 0.099,
            right: screenWidth * 0.14,
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
          // Positioned(
          //   top: screenHeight * 0.488,
          //   left: screenWidth * 0.06,
          //   child: Container(
          //     width: screenWidth * 0.27,
          //     height: screenWidth * 0.06,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 3,
          //           spreadRadius: 1,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Center(
          //       child: Text(
          //         meatName,
          //         style: TextStyle(
          //           fontSize: 13,
          //           color: Color.fromRGBO(119, 131, 143, 1.0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: screenHeight * 0.488,
          //   left: screenWidth * 0.37,
          //   child: Container(
          //     width: screenWidth * 0.27,
          //     height: screenWidth * 0.06,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 3,
          //           spreadRadius: 1,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Center(
          //       child: Text(
          //         oilName,
          //         style: TextStyle(
          //           fontSize: 13,
          //           color: Color.fromRGBO(119, 131, 143, 1.0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          // Positioned(
          //   top: screenHeight * 0.488,
          //   left: screenWidth * 0.68,
          //   child: Container(
          //     width: screenWidth * 0.27,
          //     height: screenWidth * 0.06,
          //     decoration: BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.circular(10),
          //       boxShadow: [
          //         BoxShadow(
          //           color: Colors.black.withOpacity(0.1),
          //           blurRadius: 3,
          //           spreadRadius: 1,
          //           offset: Offset(0, 2),
          //         ),
          //       ],
          //     ),
          //     child: Center(
          //       child: Text(
          //         supplementName,
          //         style: TextStyle(
          //           fontSize: 13,
          //           color: Color.fromRGBO(119, 131, 143, 1.0),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
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
              child: Center(
                child: Wrap(
                  alignment: WrapAlignment.center,
                  children: [
                    Text(
                      ' $meatDescription \n'
                      ' $oilDescription \n'
                      ' $supplementDescription',
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
            bottom: 50,
            right: 23,
            child: InkWell(
              onTap: _launchURL, // 버튼을 눌렀을 때 호출될 함수를 여기에 지정합니다.
              child: Container(
                width: screenWidth * 0.41,
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
            bottom: 50,
            left: 23,
            child: Container(
              width: screenWidth * 0.41,
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
                      padding: EdgeInsets.only(left: 10),
                      child: Icon(
                        CupertinoIcons.paperplane,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 1),
                    Expanded(
                      child: Center(
                        child: Text(
                          '피드백 보내기',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
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
