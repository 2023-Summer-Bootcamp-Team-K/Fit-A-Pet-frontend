import 'package:flutter/material.dart';
import 'package:frontend/components/info_card.dart';
import 'package:frontend/page/pet_info.dart';
import 'package:frontend/screens/chart_screen.dart';
import 'package:frontend/screens/feed.dart';
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
                name: "Duck UI",
                email: "DuckUI@demo.com",
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
                                builder: (context) => PetInfoPage()),
                          );
                        }
                      },
                      child: NewRow(
                        text: 'Pet Profile',
                        image: AssetImage('assets/icons/paw.png'),
                      ),
                    ),
                    SizedBox(height: 20),
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
                        text: 'Chart',
                        image: AssetImage('assets/icons/chart.png'),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isActive = !isActive;
                        });
                        if (isActive) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Feed_Page()),
                          );
                        }
                      },
                      child: NewRow(
                        text: 'Feed Recommendations',
                        image: AssetImage('assets/icons/feed_rcmd.png'),
                      ),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: EdgeInsets.only(left: 30, bottom: 40),
                child: InkWell(
                  onTap: () {
                    // Handle logout
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