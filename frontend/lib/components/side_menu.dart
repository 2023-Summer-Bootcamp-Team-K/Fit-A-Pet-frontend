import 'package:flutter/material.dart';
import 'package:frontend/components/info_card.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:frontend/screens/chart_screen.dart';
import 'package:frontend/screens/feed.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const SideMenu());
}

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30.0 * 2),
          ),
          color: Colors.white,
        ),
        width: 300,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InfoCard(
                name: "김주인",
                email: "OurPetIsAwesome@demo.com",
              ),
              Padding(
                padding: EdgeInsets.only(top: 40, left: 30, bottom: 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        }
                      },
                      child: NewRow(
                        text: '홈',
                        image: AssetImage('assets/icons/home.png'),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PetInfoPage()),
                          );
                        }
                      },
                      child: NewRow(
                        text: '반려동물 정보',
                        image: AssetImage('assets/icons/paw.png'),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChartScreen()),
                          );
                        }
                      },
                      child: NewRow(
                        text: '혈당 차트',
                        image: AssetImage('assets/icons/chart.png'),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Feed_Page(petID: 'your_pet_id')),
                          );
                        }
                      },
                      child: NewRow(
                        text: '사료 추천',
                        image: AssetImage('assets/icons/feed_rcmd.png'),
                      ),
                    ),
                    SizedBox(height: 40),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          _launchURL;
                        }
                      },
                      child: NewRow(
                        text: '수의사와 상담',
                        image: AssetImage('assets/icons/chat.png'),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(left: 30, bottom: 40),
                child: InkWell(
                  onTap: () {
                  },
                  child: Row(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/log_out.png',
                        width: 24,
                        height: 24,
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                            color: Colors.black.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
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

class NewRow extends StatelessWidget {
  final String text;
  final AssetImage image;

  const NewRow({
    Key? key,
    required this.text,
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Image(
          image: image,
          width: 24,
          height: 24,
        ),
        SizedBox(
          width: 20,
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ],
    );
  }
}


  
