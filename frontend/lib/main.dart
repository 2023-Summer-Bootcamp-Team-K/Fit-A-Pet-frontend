import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/components/notification.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:provider/provider.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/page/home_page.dart';
import 'package:frontend/screens/splash_screen.dart';

void main() {

  _initNotiSetting();
  runApp(MyApp());
}

void _initNotiSetting() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  final initSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  final initSettings = InitializationSettings(
    android: initSettingsAndroid,
    iOS: initSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
  );

  NotificationDetails _details = const NotificationDetails(
      android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
    
     tz.TZDateTime _timeZoneSetting({
    required int hour,
    required int minute,
  }) {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));
    tz.TZDateTime _now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, _now.year, _now.month, _now.day, hour, minute);

    return scheduledDate;
  }
}


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
            .apply(displayColor: kTextColor),
      ),
    );
  }
}