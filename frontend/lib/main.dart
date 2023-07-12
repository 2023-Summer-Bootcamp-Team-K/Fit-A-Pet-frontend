import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/entry_point.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fit-A-Pet',
      theme: ThemeData(
        primaryColor: kPrimaryColor, //상단바 컬러
        scaffoldBackgroundColor: kBackgroundColor,
        appBarTheme: AppBarTheme( //AppBar 테마 줄 없애기
          color: kPrimaryColor,
          elevation: 0,
        ),
        textTheme: Theme.of(context)
            .textTheme
            .apply(displayColor: kTextColor), //뒷배경 컬러
      ),
      home: EntryPoint(),
    );
  }
}