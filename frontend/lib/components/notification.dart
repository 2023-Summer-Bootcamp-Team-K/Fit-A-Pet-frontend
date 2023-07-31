import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:time_picker_spinner/time_picker_spinner.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationPage extends StatefulWidget {
  final String petID;

  const NotificationPage({Key? key, required this.petID}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedButtonIndex = -1;
  TimeOfDay? _selectedTime;
  bool _isNoButtonPressed = false;
  bool _isYesButtonPressed = false;

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: kPrimaryColor,
        title: Text(
          '알림 받기',
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
              PageTransition(
                type: PageTransitionType.leftToRight,
                duration: Duration(milliseconds: 250),
                child: HomeScreen(petID: widget.petID),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 70),
              Container(
                child: Text(
                  '알림 받고 싶은 시간을 설정해 주세요.',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    children: [
                      buildButton(0, '09:00', AndroidNotificationDetails('alarm 1', '1번 푸시'),
                          DarwinNotificationDetails()),
                      buildButton(1, '11:00', AndroidNotificationDetails('alarm 2', '2번 푸시'),
                          DarwinNotificationDetails()),
                      buildButton(2, '13:00', AndroidNotificationDetails('alarm 3', '3번 푸시'),
                          DarwinNotificationDetails()),
                      buildButton(3, '15:00', AndroidNotificationDetails('alarm 4', '4번 푸시'),
                          DarwinNotificationDetails()),
                      buildButton(4, '18:00', AndroidNotificationDetails('alarm 5', '5번 푸시'),
                          DarwinNotificationDetails()),
                      buildButton(5, '20:00', AndroidNotificationDetails('alarm 6', '6번 푸시'),
                          DarwinNotificationDetails()),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.fromLTRB(50, 0, 50, 10),
                child: Column(
                  children: [
                    Text(
                      '직접 시간 설정하기:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    PhysicalModel(
                      elevation: 6,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white54),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TimePickerSpinner(
                          is24HourMode: false,
                          isShowSeconds: false,
                          itemHeight: 80,
                          normalTextStyle: const TextStyle(
                            fontSize: 20,
                          ),
                          highlightedTextStyle:
                              const TextStyle(
                                fontSize: 24, 
                                color: Color.fromARGB(255, 135, 153, 239),
                                fontWeight: FontWeight.bold
                                ),
                          onTimeChange: (time) {
                            setState(() {
                              _selectedTime = TimeOfDay.fromDateTime(time);
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 50,
                    width: 330,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedButtonIndex != -1 || _selectedTime != null) {
                          AndroidNotificationDetails androidDetails =
                              AndroidNotificationDetails('channelId', 'channelName',
                                  importance: Importance.max, priority: Priority.high);
                          DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
                          if (_selectedTime != null) {
                            _scheduleNotification(androidDetails, iosDetails);
                            _TimeConfirmation(context, _selectedTime!);
                          } 
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: kPrimaryColor,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        '설정 완료',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildButton(
      int index, String label, AndroidNotificationDetails androidDetails, DarwinNotificationDetails iosDetails) {
    final isSelected = index == _selectedButtonIndex;
    final timeComponents = label.split(':');
    final hour = int.parse(timeComponents[0]);
    final minute = int.parse(timeComponents[1]);
    final time = TimeOfDay(hour: hour, minute: minute);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedButtonIndex = index;
            _selectedTime = time;
          });
        },
        style: ElevatedButton.styleFrom(
          primary: isSelected ? kPrimaryColor : Colors.white,
          onPrimary: isSelected ? Colors.white : kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future<void> _TimeConfirmation(BuildContext context, TimeOfDay selectedTime) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: Color(0xFF878CEF),
              ),
              SizedBox(width: 8),
              Text('알림 확인'),
            ],
          ),
          content: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('설정한 시간에 알림을 받으시겠습니까?'),
            SizedBox(height: 10),
            Text(
              '선택한 시간: ${selectedTime.format(context)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isYesButtonPressed
                            ? Color(0xFFC1CCFF).withAlpha(128)
                            : Colors.white, 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          '예',
                          style: TextStyle(
                            color: Color(0xFF878CEF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                          _isYesButtonPressed = true; 
                          _isNoButtonPressed = false; 
                          });
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                              msg: "   알림 설정이 완료되었습니다.   ",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 5,
                              backgroundColor: kPrimaryColor,
                              textColor: Colors.white,
                              webShowClose: true,
                              fontSize: 16.0
                          );
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _isNoButtonPressed
                            ? Color(0xFFC1CCFF).withAlpha(128) 
                            : Colors.white, 
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        child: Text(
                          '아니요',
                          style: TextStyle(
                            color: Color(0xFF878CEF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _isNoButtonPressed = !_isNoButtonPressed;
                          });
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) {
      setState(() {
        _isYesButtonPressed = false;
        _isNoButtonPressed = false;
      });
    });
  }

  void _scheduleNotification(
      AndroidNotificationDetails androidDetails, DarwinNotificationDetails iosDetails) async {
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

      final notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
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

      tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
        scheduledDate,
        tz.local,
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        '기기 태깅 알림',
        '기기에 스마트폰을 태그할 시간입니다.',
        scheduledDateTime,
        notificationDetails,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    }
  }
}