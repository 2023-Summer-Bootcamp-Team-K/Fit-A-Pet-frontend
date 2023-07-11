import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/widgets/daily_chart.dart' as DailyChartWidget;
import 'package:frontend/widgets/weekly_chart.dart' as WeeklyChartWidget;
import 'package:frontend/widgets/monthly_chart.dart' as MonthlyChartWidget;

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int _selectedIndex = 0;
  List<DateTime> dates = [
    DateTime.now(),
    DateTime.now().add(Duration(days: 1)),
    DateTime.now().add(Duration(days: 2)),
    DateTime.now().add(Duration(days: 3)),
    DateTime.now().add(Duration(days: 4)),
    DateTime.now().add(Duration(days: 5)),
    DateTime.now().add(Duration(days: 6)),
  ];

  List<Widget> _chartWidgets = [
    DailyChartWidget.DailyChart(),
    WeeklyChartWidget.WeeklyChart(),
    MonthlyChartWidget.MonthlyChart(),
  ];

  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;

      // Increment dates by 1 starting from the selected index
      for (int i = index + 1; i < dates.length; i++) {
        dates[i] = dates[i - 1].add(Duration(days: 1));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = 0;
    switch (_selectedIndex) {
      case 0:
        itemCount = 7;
        break;
      case 1:
        itemCount = 4;
        break;
      case 2:
        itemCount = 1;
        break;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: buildDetailsAppBar(context),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _onTogglePressed(0),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 0 ? kShadowColor : Colors.white,
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
                  onTap: () => _onTogglePressed(1),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 1 ? kShadowColor : Colors.white,
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
                  onTap: () => _onTogglePressed(2),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 2 ? kShadowColor : Colors.white,
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
              itemCount: itemCount,
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
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: currentDate,
                            firstDate: DateTime(2022),
                            lastDate: DateTime.now().subtract(Duration(days: 1)),
                            initialEntryMode: DatePickerEntryMode.calendarOnly,
                          );
                          if (selectedDate != null) {
                            setState(() {
                              dates[index] = selectedDate;
                              for (int i = index + 1; i < dates.length; i++) {
                                dates[i] = dates[i - 1].add(Duration(days: 1));
                              }
                            });
                          }
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
      title: Text("Chart"),
      backgroundColor: kBackgroundColor,
      elevation: 0,
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
    );
  }
}
