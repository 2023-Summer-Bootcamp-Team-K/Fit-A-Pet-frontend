import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/components/notification.dart';
import 'package:frontend/components/side_menu.dart';
import 'package:frontend/constant.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:frontend/screens/feed.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

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
              borderRadius: isDrawerOpen ? BorderRadius.circular(40) : BorderRadius.circular(0),
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
                              MaterialPageRoute(builder: (context) => NotificationPage()),
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
                              SizedBox(width: screenWidth * 0.03),
                              Transform.translate(
                                offset: Offset(0, -screenWidth * 0.02),
                                child: Text(
                                  'Hi!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: screenWidth * 0.09,
                                    fontWeight: FontWeight.bold,
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
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                      'Fit-A-Pet Will Help you to Improve your Pet Health',
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
                                'assets/main_doctor.png',
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.6,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.5,
                        child: Container(
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xffF4DCF0),
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                top: screenWidth * 0.025,
                                left: screenWidth * 0.025,
                                child: Image.asset(
                                  'assets/spoid.png',
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                ),
                              ),
                              Center(
                                child: Text(
                                  '최근 혈당, 체크한 시간',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xFFFEFFC9),
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                top: screenWidth * 0.025,
                                left: screenWidth * 0.025,
                                child: Image.asset(
                                  'assets/blood.png',
                                  width: screenWidth * 0.08,
                                  height: screenWidth * 0.08,
                                ),
                              ),
                              Center(
                                child: Text(
                                  '평균혈당',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.bold,
                                  ),
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
                        child: Container(
                          width: screenWidth * 0.9,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: Color(0xFFF86A1FF),
                            borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '혈당차트',
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
                                'assets/bloodchart.png',
                                width: screenWidth * 0.15,
                                height: screenWidth * 0.15,
                              ),
                              SizedBox(width: screenWidth * 0.05),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 1.4,
                        left: screenWidth * 0.05,
                        right: screenWidth * 0.05,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(milliseconds: 500),
                                pageBuilder: (_, __, ___) => Feed_Page(),
                                transitionsBuilder: (_, animation, __, child) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            width: screenWidth * 0.6,
                            height: screenWidth * 0.3,
                            decoration: BoxDecoration(
                              color: Color(0xFFF86A1FF),
                              borderRadius: BorderRadius.circular(screenWidth * 0.05),
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
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '사료추천',
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
                                  'assets/feed.png',
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
                      bottom: screenWidth * 0.25,
                      right: 30,
                      child: FloatingActionButton(
                        backgroundColor: Colors.white,
                        onPressed: _launchURL,
                        child: Image.asset(
                          'assets/kakao_icon.png',
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
  _launchURL() async {
    const url = 'https://open.kakao.com/o/sOmd7Zuf';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }     
}