import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/notification.dart';
import 'package:frontend/components/side_menu.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/chart_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/screens/feed.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;
  String petID = '10';
  double? hba1c;
  String? recentTimestamp;
  int? recentBloodSugar;
  String petName = '';

  @override
  void initState() {
    super.initState();
    fetchHba1cData();
    fetchRecentBloodSugarData(petID);
    fetchPetData();
  }

  String extractTimeFromTimestamp(String? timestamp) {
    if (timestamp == null) return '';

    final DateTime dateTime = DateTime.parse(timestamp);
    final String formattedTime =
        DateFormat('M월 d일 HH시 mm분').format(dateTime);
    return formattedTime;
  }

  Future<void> fetchHba1cData() async {
    String Hba1curl = 'http://54.180.70.169/api/data/hba1c/10/';

    try {
      final response = await http.get(
        Uri.parse(Hba1curl),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        double? newHba1c =
            responseData['hba1c'];

        if (newHba1c != null) {
          setState(() {
            hba1c = newHba1c;
          });
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> fetchRecentBloodSugarData(String petId) async {
    String apiUrl = 'http://54.180.70.169/api/data/recent/10/';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        String? timestamp = responseData['timestamp'];
        int? bloodSugar = responseData['scan_bloodsugar'];

        if (timestamp != null && bloodSugar != null) {
          setState(() {
            recentTimestamp = DateTime.parse(timestamp).toString();
            recentBloodSugar = bloodSugar;
          });
        }
      } else {
        throw Exception('데이터를 불러오지 못했습니다');
      }
    } catch (error) {
      throw Exception('에러: $error');
    }
  }

  void fetchPetData() async { // petID 파라미터를 제거
  String apiUrlForPet = 'http://54.180.70.169/api/pets/detail/$petID/';

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
      body: Stack(
        children: [
          SideMenu(),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 1.00 : 1.00),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 70),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        isDrawerOpen
                            ? GestureDetector(
                                child: Icon(Icons.arrow_back_ios),
                                onTap: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    isDrawerOpen = false;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Icon(Icons.menu),
                                onTap: () {
                                  setState(() {
                                    xOffset = 300;
                                    yOffset = 0;
                                    isDrawerOpen = true;
                                  });
                                },
                              ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationPage()),
                            );
                          },
                          child: Icon(CupertinoIcons.bell_fill),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: screenHeight,
                        color: Colors.grey[200],
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Color(0xFFFC1CCFF),
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(screenWidth * 0.1),
                              bottomLeft: Radius.circular(screenWidth * 0.1),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(width: screenWidth * 0.055),
                              Transform.translate(
                                offset: Offset(0, -screenWidth * 0.02),
                                child: Text(
                                  ' $petName, 반가워요!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.09,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Fit-A-Pet-Hi',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.25,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: screenWidth * 0.05),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '반려동물의 건강을',
                                      style: TextStyle(
                                        color: Color(0xff5551ff),
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    Text(
                                      '우선시하는',
                                      style: TextStyle(
                                        color: Color(0xff5551ff),
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height:5),
                                    Text(
                                      'Fit-A-Pet 입니다.',
                                      style: TextStyle(
                                        color: Color(0xff5551ff),
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.05),
                              Image.asset(
                                'images/doctor.png',
                                width: screenWidth * 0.3,
                                height: screenWidth * 0.4,
                                scale: 1,
                              ),
                              SizedBox(width: screenWidth * 0.03),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.6,
                        left: screenWidth * 0.05,
                        child: Container(
                          width: screenWidth * 0.42,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 191, 227, 255),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: screenWidth * 0.035,
                                left: screenWidth * 0.025,
                                child: Image.asset(
                                  'images/spoid.png',
                                  width: screenWidth * 0.1,
                                  height: screenWidth * 0.08,
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.045,
                                left: screenWidth * 0.135,
                                child: Text(
                                  '최근 혈당',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.2,
                                right: screenWidth * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$recentBloodSugar',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Fit-A-Pet-Num',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.31,
                                right: screenWidth * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'mg/dL',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Fit-A-Pet-MG',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.13,
                                right: screenWidth * 0.06,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '${extractTimeFromTimestamp(recentTimestamp)}',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.6,
                        right: screenWidth * 0.05,
                        child: Container(
                          width: screenWidth * 0.42,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xFFFEFFC9),
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.05),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: screenWidth * 0.03,
                                left: screenWidth * 0.025,
                                child: Image.asset(
                                  'images/blood.png',
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.045,
                                left: screenWidth * 0.135,
                                child: Text(
                                  '당화혈색소',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.32,
                                right: screenWidth * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '%',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Fit-A-Pet-MG',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: screenWidth * 0.2,
                                right: screenWidth * 0.05,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$hba1c',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Fit-A-Pet-Num',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 1.05,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.bottomToTop,
                                duration: Duration(milliseconds: 250),
                                child: ChartScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.9,
                            height: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              color: Color(0xFFF86A1FF),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth * 0.1),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '혈당 차트 분석',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Image.asset(
                                  'images/bloodchart.png',
                                  width: screenWidth * 0.15,
                                  height: screenWidth * 0.15,
                                ),
                                SizedBox(width: screenWidth * 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 1.4,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            _onRecommendationButtonPressed(context);
                          },
                          child: Container(
                            width: screenWidth * 0.6,
                            height: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              color: Color(0xFFF86A1FF),
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: screenWidth * 0.1),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '사료 추천',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: screenWidth * 0.06,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.05),
                                Image.asset(
                                  'images/feed.png',
                                  width: screenWidth * 0.15,
                                  height: screenWidth * 0.15,
                                ),
                                SizedBox(width: screenWidth * 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: screenWidth * 0.28,
                        right: screenWidth * 0.06,
                        child: FloatingActionButton(
                          backgroundColor: Colors.white,
                          onPressed: _launchURL,
                          child: Image.asset(
                            'assets/icons/kakao_icon.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onRecommendationButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.bottomToTop, // 애니메이션을 bottomToTop으로 설정합니다.
        duration: Duration(milliseconds: 250),
        child: Feed_Page(petID: petID), // Feed_Page로 petID를 넘겨줍니다.
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