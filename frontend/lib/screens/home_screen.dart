import 'package:flutter/material.dart';
import 'package:frontend/components/side_menu.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/models/menu_btn.dart';
import 'package:frontend/utils/rive_utils.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  bool isSideBarOpen = false;

  late SMIBool isMenuOpenInput;

  late AnimationController _animationController;
  late Animation<double> scalAnimation;
  late Animation<double> animation;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        setState(() {});
      });

    scalAnimation = Tween<double>(begin: 1, end: 0.8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.fastOutSlowIn,
    ));

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleSideBar() {
    isMenuOpenInput.value = !isMenuOpenInput.value;
    if (_animationController.value == 0) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    setState(() {
      isSideBarOpen = !isSideBarOpen;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        leading: menuBtn(
          riveOnit: (artboard) {
            final controller = RiveUtils.getRiveController(
              artboard,
              stateMachineName: "State Machine",
            );
            isMenuOpenInput = controller.findInput<bool>("isOpen") as SMIBool;
            isMenuOpenInput.value = true;
          },
          press: toggleSideBar,
        ),
      ),
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            width: 288,
            height: MediaQuery.of(context).size.height,
            left: isSideBarOpen ? 0 : -288,
            top: 0,
            child: const SideMenu(),
          ),
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(
                  1 * animation.value - 30 * animation.value * 3.14159 / 180),
            child: Transform.translate(
              offset: Offset(animation.value * 265, 0),
              child: Transform.scale(
                scale: scalAnimation.value,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: kBackgroundColor,
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          width: double.infinity,
                          height: screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(
                                  screenWidth * 0.1),
                              bottomLeft: Radius.circular(
                                  screenWidth * 0.1),
                            ),
                          ),
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: screenWidth * 0.03,
                              ),
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
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Fit-A-Pet Will Help you to Improve your Pet Health!',
                                      style: TextStyle(
                                        color: Color(0xff5551ff),
                                        fontSize: screenWidth * 0.05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                              Image.asset(
                                'assets/main_doctor.png',
                                width: screenWidth * 0.2,
                                height: screenWidth * 0.2,
                              ),
                              SizedBox(
                                width: screenWidth * 0.05,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: screenWidth * 0.6,
                        left: screenWidth * 0.05,
                        child: Container(
                          width: screenWidth * 0.4,
                          height: screenWidth * 0.4,
                          decoration: BoxDecoration(
                            color: Color(0xffF4DCF0),
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
                                  '최근 혈당, 혈당 체크한 시간',
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
                                  '평균 혈당',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.035,
                                    fontWeight: FontWeight.bold,
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
                color: Color.fromRGBO(134, 161, 255, 1),
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
                          '혈당 차트',
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
            top: screenWidth * 1.40,
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
                    'assets/feed.png',
                    width: screenWidth * 0.15,
                    height: screenWidth * 0.15,
                  ),
                  SizedBox(width: screenWidth * 0.05),
                ],
              ),
                           ),
                           ),
                          ],
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
}
