import 'package:flutter/material.dart';
import 'package:frontend/components/side_menu.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/widgets/daily_chart.dart';
import 'package:frontend/widgets/monthly_chart.dart';
import 'package:frontend/widgets/weekly_chart.dart';

class ChartScreen extends StatefulWidget {
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {
  // Variables to handle side menu animation
  double xOffset = 0;
  double yOffset = 0;
  bool isDrawerOpen = false;

  // Variables to manage date selection and chart data
  DateTime selectedDate = DateTime.now();
  int petId = 10;
  List<Widget> _chartWidgets = [];
  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Initialize the chart widgets list with the initial charts
    _chartWidgets = [
      DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected),
      WeeklyChart(
        petId: petId,
        startMonth: startDate.month,
        startDay: startDate.day,
        endMonth: endDate.month,
        endDay: endDate.day,
      ),
      MonthlyChart(petId, selectedYear, selectedMonth),
    ];
  }

  // Function to initialize the selected month with the current month
  void _initSelectedMonth() {
    selectedMonth = DateTime.now().month;
  }

  // Function to format the date range for the selected dates
  String getFormattedDateRange(PickerDateRange? range) {
    if (range != null && range.startDate != null && range.endDate != null) {
      String formattedStartDate = DateFormat("M월 d일").format(range.startDate!);
      String formattedEndDate = DateFormat("M월 d일").format(range.endDate!);
      return "$formattedStartDate - $formattedEndDate";
    } else {
      return "";
    }
  }

  // Function to get the start of the current month as DateTime
  DateTime getCurrentMonthDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  // Function to initialize the selected year with the current year
  void _initSelectedYear() {
    setState(() {
      selectedYear = DateTime.now().year;
    });
  }

  // Function to handle the chart selection toggle
  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;
      // If the third chart (monthly) is selected, initialize the selected month and year
      if (_selectedIndex == 2) {
        _initSelectedMonth();
        _initSelectedYear();
      }
    });
  }

  // Function to update the selected date and rebuild the daily chart
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

  // Function to handle the date selection on the daily chart
  void onDateSelected(DateTime newDate) {
    setState(() {
      selectedDate = newDate;
      // Update the daily chart with the selected date
      _chartWidgets[0] = DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected);
    });
  }

  // Function to show the date picker dialog
  Future<void> _showDatePicker(BuildContext context) async {
    DateRangePickerSelectionMode selectionMode;

    if (_selectedIndex == 0) {
      selectionMode = DateRangePickerSelectionMode.single;
    } else if (_selectedIndex == 1) {
      selectionMode = DateRangePickerSelectionMode.range;
    } else {
      selectionMode = DateRangePickerSelectionMode.single;
    }

    final SfDateRangePicker picker = SfDateRangePicker(
      // Handling date selection changes
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (_selectedIndex != 0 && args.value is PickerDateRange) {
          // For the weekly chart, update the start and end dates
          setState(() {
            startDate = args.value.startDate!;
            endDate = args.value.endDate!;
          });
          String formattedDate = getFormattedDateRange(args.value);
          print('Formatted Date: $formattedDate');
        } else if (_selectedIndex == 0 && args.value is DateTime) {
          // For the daily chart, update the selected date
          setState(() {
            selectedDate = args.value;
          });
          String formattedDate = "${selectedDate.month}월 ${selectedDate.day}일";
          print('Formatted Date: $formattedDate');
        } else if (_selectedIndex == 2 && args.value is DateTime) {
          // For the monthly chart, update the selected month
          setState(() {
            selectedMonth = args.value.month;
          });
          String formattedMonth = "${selectedMonth}월";
          print('Selected Month: $formattedMonth');
        }
      },
      startRangeSelectionColor: kPrimaryColor,
      endRangeSelectionColor: kPrimaryColor,
      rangeSelectionColor: Color.fromARGB(100, 135, 153, 239),
      selectionTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      todayHighlightColor: kPrimaryColor,
      selectionColor: kPrimaryColor,
      minDate: DateTime(2022),
      maxDate: DateTime.now(),
      selectionMode: selectionMode,
      headerStyle: const DateRangePickerHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 135, 153, 239),
          fontSize: 24,
        ),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.45,
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
                // Update the appropriate chart based on the selection
                if (startDate != null && endDate != null) {
                  _chartWidgets[1] = WeeklyChart(
                    petId: petId,
                    startMonth: startDate.month,
                    startDay: startDate.day,
                    endMonth: endDate.month,
                    endDay: endDate.day,
                  );
                }
                if (selectedDate != null) {
                  _chartWidgets[0] = DailyChart(petId, selectedDate.month, selectedDate.day, onDateSelected);
                }
                if (selectedMonth != null) {
                  _chartWidgets[2] = MonthlyChart(petId, selectedYear, selectedMonth);
                }
              });
              Navigator.pop(context);
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  // Function to show the month picker dialog
  Future<void> _showMonthPicker(BuildContext context) async {
    final SfDateRangePicker picker = SfDateRangePicker(
      view: DateRangePickerView.year,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          setState(() {
            selectedMonth = args.value.startDate!.month;
            selectedYear = args.value.startDate!.year;
            _chartWidgets[2] = MonthlyChart(petId, selectedYear, selectedMonth);
          });
        }
      },
      startRangeSelectionColor: kPrimaryColor,
      endRangeSelectionColor: kPrimaryColor,
      rangeSelectionColor: Color.fromARGB(100, 135, 153, 239),
      selectionTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      todayHighlightColor: kPrimaryColor,
      selectionColor: kPrimaryColor,
      minDate: DateTime(2022),
      maxDate: DateTime.now(),
      headerStyle: const DateRangePickerHeaderStyle(
        textStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(255, 135, 153, 239),
          fontSize: 24,
        ),
      ),
    );

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.45,
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
                _chartWidgets[2] = MonthlyChart(petId, selectedYear, selectedMonth);
              });
              Navigator.pop(context);
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  // Function to toggle the side menu
  void toggleSideMenu() {
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      xOffset = isDrawerOpen ? 300 : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          // The side menu
          SideMenu(),
          // The main content with animated container for side menu transition
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(isDrawerOpen ? 1.00 : 1.00),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: isDrawerOpen
                  ? BorderRadius.circular(40)
                  : BorderRadius.circular(0),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 70),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Toggle button to open/close the side menu
                        isDrawerOpen
                            ? GestureDetector(
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.white
                                  ),
                                onTap: () {
                                  setState(() {
                                    xOffset = 0;
                                    yOffset = 0;
                                    isDrawerOpen = false;
                                  });
                                },
                              )
                            : GestureDetector(
                                child: Icon(
                                  Icons.menu,
                                color: Colors.white
                                ),
                                onTap: () {
                                  setState(() {
                                    xOffset = 300;
                                    yOffset = 0;
                                    isDrawerOpen = true;
                                  });
                                },
                              ),
                        Text(
                          "차트 분석",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 23,
                          ),
                        ),
                        SizedBox(width: 50),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: [
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
                                height: 40,
                                width: 50,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _selectedIndex == 0
                                      ? Color.fromARGB(255, 135, 153, 239)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 21),
                                      blurRadius: 80,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "일",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
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
                                height: 40,
                                width: 50,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _selectedIndex == 1
                                      ? Color.fromARGB(255, 135, 153, 239)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 21),
                                      blurRadius: 80,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "주",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedIndex == 1 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,     
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
                                height: 40,
                                width: 50,
                                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: _selectedIndex == 2
                                      ? Color.fromARGB(255, 135, 153, 239)
                                      : Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 21),
                                      blurRadius: 80,
                                      color: Colors.black.withOpacity(0.1),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "월",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: _selectedIndex == 2 ? Colors.white : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20), // Add this line to create space between the toggle buttons and the container with charts
                      Container(
                        height: 350,
                        margin: EdgeInsets.fromLTRB(20, 0, 22, 0),
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
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
                              width: _selectedIndex == 0
                                  ? 130
                                  : _selectedIndex == 1
                                      ? 200
                                      : 100,
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (_selectedIndex == 2) {
                                    await _showMonthPicker(context);
                                  } else {
                                    await _showDatePicker(context);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: kPrimaryColor,
                                  padding: EdgeInsets.symmetric(
                                    vertical: 10,
                                    horizontal: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                                      _selectedIndex == 0
                                          ? DateFormat("M월 d일").format(selectedDate)
                                          : _selectedIndex == 1
                                              ? getFormattedDateRange(PickerDateRange(startDate, endDate))
                                              : "${selectedMonth}월",
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
                            SizedBox(height: 20),
                            // Display the selected chart based on the current index
                            _chartWidgets[_selectedIndex],
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                        alignment: Alignment.bottomCenter,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 110,
                                  width: 390,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 232, 244, 255),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '혈당 범위',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '정상 범위 - 70~140mg/dl(개, 고양이)',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '당뇨 시 - 개 : 200mg/dl, 고양이: 250mg/dl',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),
                            Column(
                              children: [
                                Container(
                                  alignment: Alignment.topLeft,
                                  height: 230,
                                  width: 390,
                                  padding: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 253, 243),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '주의 사항',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '1. 인슐린 투여 후 최저점',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '    (1) 150mg/dl 이하 - 경계',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '    (2) 120mg/dl 이하 - 주의',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '    (3) 100mg/dl 이하 - 병원 내원 및 당 섭취 권고',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '2. 사료 섭취 후 기울기 변화',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '    (1) 고혈당 사료/간식 : 100mg/dl 이상 상승',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Text(
                                        '    (2) 저혈당 사료/간식 : 30mg/dl 이상 상승',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

