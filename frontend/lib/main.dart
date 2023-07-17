import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = '팻';
  final user = User();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Splash(),
    );
  }
} 

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //앱바
        backgroundColor: kPrimaryColor, //연보라색
        title: Text("Fit-A-Pet"),
      ),
      body: Container(
        //컨테이너 //homepage
        child: Center(
          child: Text("HomePage"),
        ),
        textTheme: Theme.of(context)
            .textTheme
            .apply(displayColor: kTextColor), //뒷배경 컬러
      ),
    );
  }
}