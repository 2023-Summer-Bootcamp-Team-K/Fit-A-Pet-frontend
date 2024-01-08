import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SocialLoginScreen extends StatefulWidget {

  @override
  _SocialLoginScreenState createState() => _SocialLoginScreenState();
}

class _SocialLoginScreenState extends State<SocialLoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RotatedBox(
                  quarterTurns: 1,
                  child: Container(
                    height: 500,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Color(0xFFFC1CCFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        bottomLeft: Radius.circular(50),
                      ),
                  ),
                  ),
            ),
            SizedBox(height: 20),
            Row(children:[
              SizedBox(width: 15),
              Text(
              'Sign in',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w400,
                fontFamily: 'Fit-A-Pet-Num',
              ),
            ),
            Image.asset(
              'images/lock.png', 
              height: 50, 
            ), 
            ]
            ), 
            SizedBox(height: 10),
            Row(children: [
              SizedBox(width: 15),
              Text(
              'to continue to Fit-A-Pet',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
                fontWeight: FontWeight.w300,

              ),
            ), 
            ],
            ),      
            SizedBox(height: 170),
            SocialLoginButton(
              text: 'Login with Gmail',
              onPressed: () {
                // Gmail 로그인 처리
              },
            ),
            SizedBox(height: 65),
            SocialLoginButton(
              text: 'Login with KaKao Mail',
              onPressed: () {
                // KaKao Mail 로그인 처리
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SocialLoginButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  //SocialLoginButton({required this.text, required this.icon, required this.onPressed});
  SocialLoginButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: Colors.white,
        onPrimary: Colors.black,
        padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25)
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //Icon(icon, color: Colors.black),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}