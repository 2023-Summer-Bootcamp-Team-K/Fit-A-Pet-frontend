import 'package:flutter/material.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/widgets/daily_chart.dart';
import 'package:frontend/widgets/monthly_chart.dart';
import 'package:frontend/widgets/weekly_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  int _selectedIndex = 0;
  DateTime selectedDate = DateTime.now();
  int petId = 105;
  List<Widget> _chartWidgets = [];

  @override
  void initState() {
    super.initState();
    _chartWidgets = [
      DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected),
      WeeklyChart(),
      MonthlyChart(),
    ];
  }

  String getFormattedDateRange(PickerDateRange range) {
    String formattedStartDate =
        DateFormat("M월 d일").format(range.startDate!);
    String formattedEndDate = DateFormat("M월 d일").format(range.endDate!);
    return "$formattedStartDate - $formattedEndDate";
  }

  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _updateSelectedDate() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (newDate != null) {
      setState(() {
        selectedDate = newDate;
      });
    }
  }

  void onDateSelected(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      _chartWidgets[0] = DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected);
    });
  }

 Future<void> _showDatePicker(BuildContext context) async {
    DateRangePickerSelectionMode selectionMode;
    DateTime? StartDate;
    DateTime? EndDate;

    if (_selectedIndex == 0) {
      selectionMode = DateRangePickerSelectionMode.single;
    } else {
      selectionMode = DateRangePickerSelectionMode.range;
    }

    final SfDateRangePicker picker = SfDateRangePicker(
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (_selectedIndex != 0 && args.value is PickerDateRange) {
          StartDate = args.value.startDate!;
          EndDate = args.value.endDate!;
        } else if (_selectedIndex == 0 && args.value is DateTime) {
          StartDate = args.value;
          EndDate = args.value;
        }
      },

      startRangeSelectionColor: kPrimaryColor,
      endRangeSelectionColor: kPrimaryColor,
      rangeSelectionColor: kPrimaryColor,
      selectionTextStyle: const TextStyle(color: Colors.white),
      todayHighlightColor: kPrimaryColor,
      selectionColor: kPrimaryColor,
      minDate: DateTime(2022),
      maxDate: DateTime.now(),
      selectionMode: selectionMode,
      headerStyle: const DateRangePickerHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 135, 153, 239),
          fontSize: 18,
        ),
      ),
    );

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.height * 0.5,
        child: picker,
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 135, 153, 239),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 3,
          ),
          onPressed: () {
            setState(() {
                selectedDate = StartDate!;
                _chartWidgets[0] = DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected);
              });
            Navigator.pop(context);
          },
          child: Text("확인"),
        ),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      resizeToAvoidBottomInset: false,
      appBar: buildDetailsAppBar(context),
      body: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    _onTogglePressed(0);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 0
                          ? Color.fromARGB(255, 135, 153, 239)
                          : Colors.white,
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 1
                          ? Color.fromARGB(255, 135, 153, 239)
                          : Colors.white,
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
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: _selectedIndex == 2
                          ? Color.fromARGB(255, 135, 153, 239)
                          : Colors.white,
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
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(22),
              itemCount: 1,
              itemBuilder: (context, index) {
                String formattedDate = "${selectedDate.month}월 ${selectedDate.day}일";
                return Container(
                  margin: EdgeInsets.only(bottom: 5), 
                  padding: EdgeInsets.fromLTRB(15, 15, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
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
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () async {
                            await _showDatePicker(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: kPrimaryColor,
                            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            elevation: 5,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.calendar_today,
                                color: Colors.white,
                              ),
                              SizedBox(width: 8),
                              Text(
                                getFormattedDateRange(PickerDateRange(selectedDate, selectedDate)),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 65), // Adjust the spacing here
                      _chartWidgets[_selectedIndex],
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      alignment: Alignment.topCenter,
                      height: 360,
                      width: MediaQuery.of(context).size.width * 0.43,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 232, 244, 255),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Spike가 위로 솟을 때',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Container(
                      alignment: Alignment.topCenter,
                      height: 360,
                      width: MediaQuery.of(context).size.width * 0.43,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 253, 243),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'Spike가 아래로 들어갔을 때',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
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
      title: Text("차트 분석"),
      titleTextStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
      backgroundColor: kPrimaryColor,
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
