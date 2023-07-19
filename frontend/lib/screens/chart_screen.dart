import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/widgets/daily_chart.dart';
import 'package:frontend/widgets/monthly_chart.dart';
import 'package:frontend/widgets/weekly_chart.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int _selectedIndex = 0;
  List<DateTime> dates = [];
  int petId = 105;
  List<Widget> _chartWidgets = [];

  @override
  void initState() {
    super.initState();
    _setDates(DateTime.now());
    _chartWidgets = [
      DailyChart(petId),
      WeeklyChart(),
      MonthlyChart(),
    ];
  }

  void _setDates(DateTime selectedDate) {
    dates.clear();
    for (int i = 6; i >= 0; i--) {
      dates.add(selectedDate.subtract(Duration(days: i)));
    }
  }

  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final initialDate = dates[0];
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
    );

    if (selectedDate != null) {
      _setDates(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildDetailsAppBar(context),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _onTogglePressed(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 0 ? kPrimaryColor : Colors.white,
                    ),
                    child: Text(
                      "일",
                      style: TextStyle(
                        color: _selectedIndex == 0 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _onTogglePressed(1);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 1 ? kPrimaryColor : Colors.white,
                    ),
                    child: Text(
                      "주",
                      style: TextStyle(
                        color: _selectedIndex == 1 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _onTogglePressed(2);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 2 ? kPrimaryColor : Colors.white,
                    ),
                    child: Text(
                      "월",
                      style: TextStyle(
                        color: _selectedIndex == 2 ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: dates.length,
              itemBuilder: (context, index) {
                DateTime currentDate = dates[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 21),
                        blurRadius: 80,
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () async {
                          await _showDatePicker(context);
                        },
                        child: Text(
                          "${currentDate.month}월 ${currentDate.day}일",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      SizedBox(height: 70),
                      _chartWidgets[_selectedIndex],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildDetailsAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      title: Text("Chart"),
      backgroundColor: Color(0xFFC1CCFF),
      leading: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: Duration(milliseconds: 500),
              pageBuilder: (_, __, ___) => HomeScreen(),
              transitionsBuilder: (_, animation, __, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        },
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
    );
  }
}
