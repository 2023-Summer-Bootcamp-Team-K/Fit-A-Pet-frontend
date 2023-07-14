import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:time_picker_spinner/time_picker_spinner.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedButtonIndex = -1;
  TimeOfDay? _selectedTime; // 추가: 선택한 시간을 저장하는 변수

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones(); // 시간대 초기화
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          'Notification',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          // Positioned.fill(
          //   child: Image.asset(
          //     'assets/background.jpeg',
          //     fit: BoxFit.cover,
          //   ),
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 70),
              Container(
                child: Text(
                  '기기를 태그할 시간을 정해주세요!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      buildButton(0, '09:00'),
                      buildButton(1, '11:00'),
                      buildButton(2, '13:00'),
                      buildButton(3, '15:00'),
                      buildButton(4, '18:00'),
                      buildButton(5, '20:00'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 40),
              TimePickerSpinner(
                is24HourMode: false,
                isShowSeconds: false,
                itemHeight: 80,
                normalTextStyle: const TextStyle(
                  fontSize: 20,
                ),
                highlightedTextStyle: const TextStyle(fontSize: 23, color: Colors.red),
                onTimeChange: (time) {
                  setState(() {
                    _selectedButtonIndex = -1;
                    _selectedTime = TimeOfDay.fromDateTime(time);
                  });
                },
              ),
              SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    _scheduleNotification();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: kPrimaryColor,
                    onPrimary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text('설정 완료'),
                ),
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(int index, String label) {
    final isSelected = index == _selectedButtonIndex;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedButtonIndex = index;
            _selectedTime = null;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: isSelected ? kPrimaryColor : Colors.white,
          onPrimary: isSelected ? Colors.white : Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(label),
      ),
    );
  }

  void _scheduleNotification() async {
    if (_selectedTime != null) {
      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      final initSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      final initSettingsIOS = DarwinInitializationSettings();
      final initSettings = InitializationSettings(
        android: initSettingsAndroid,
        iOS: initSettingsIOS,
      );
      await flutterLocalNotificationsPlugin.initialize(
        initSettings,
      );

      NotificationDetails _details = const NotificationDetails(
        android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
        iOS: DarwinNotificationDetails(),
      );

      DateTime now = DateTime.now();
      DateTime scheduledDate = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (scheduledDate.isBefore(DateTime.now())) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }

      tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(scheduledDate, tz.local);

      // Schedule notification using scheduledDateTime
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '기기 태깅 알림',
        '8시간 안에 기기에 스마트폰을 태그해야 합니다.',
        scheduledDateTime,
        _details,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }
  }
}
