import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:frontend/constant.dart';
import 'package:frontend/widgets/daily_chart.dart';
import 'package:frontend/widgets/monthly_chart.dart';
import 'package:frontend/widgets/weekly_chart.dart';

class ChartScreen extends StatefulWidget {
  final String petID;

  ChartScreen({required this.petID});
  
  @override
  _ChartScreenState createState() => _ChartScreenState();
}

class _ChartScreenState extends State<ChartScreen> {

  DateTime selectedDate = DateTime.now();
  int petID = 0;
  List<Widget> _chartWidgets = [];
  DateTime startDate = DateTime.now().subtract(Duration(days: 7));
  DateTime endDate = DateTime.now();
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    int petId = int.parse(widget.petID);
    petID = petId;
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

  void _initSelectedMonth() {
    selectedMonth = DateTime.now().month;
  }

  String getFormattedDateRange(PickerDateRange? range) {
    if (range != null && range.startDate != null && range.endDate != null) {
      String formattedStartDate = DateFormat("M월 d일").format(range.startDate!);
      String formattedEndDate = DateFormat("M월 d일").format(range.endDate!);
      return "$formattedStartDate - $formattedEndDate";
    } else {
      return "";
    }
  }

  DateTime getCurrentMonthDateTime() {
    final now = DateTime.now();
    return DateTime(now.year, now.month);
  }

  void _initSelectedYear() {
    setState(() {
      selectedYear = DateTime.now().year;
    });
  }

  void _onTogglePressed(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 2) {
        _initSelectedMonth();
        _initSelectedYear();
      }
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
      _chartWidgets[0] = DailyChart(petID, selectedDate.month, selectedDate.day, onDateSelected);
    });
  }

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
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (_selectedIndex != 0 && args.value is PickerDateRange) {
          setState(() {
            startDate = args.value.startDate!;
            endDate = args.value.endDate!;
          });
          String formattedDate = getFormattedDateRange(args.value);
          
          
          ('Formatted Date: $formattedDate');
        } else if (_selectedIndex == 0 && args.value is DateTime) {
          setState(() {
            selectedDate = args.value;
          });
          String formattedDate = "${selectedDate.month}월 ${selectedDate.day}일";
        } else if (_selectedIndex == 2 && args.value is DateTime) {
          setState(() {
            selectedMonth = args.value.month;
          });
          String formattedMonth = "${selectedMonth}월";
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
      monthCellStyle: DateRangePickerMonthCellStyle(
        todayTextStyle: TextStyle(
          color: Color.fromARGB(255, 135, 153, 239), 
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(
          color: Color.fromARGB(255, 135, 153, 239), 
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
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
                if (startDate != null && endDate != null) {
                  _chartWidgets[1] = WeeklyChart(
                    petId: petID,
                    startMonth: startDate.month,
                    startDay: startDate.day,
                    endMonth: endDate.month,
                    endDay: endDate.day,
                  );
                }
                if (selectedDate != null) {
                  _chartWidgets[0] = DailyChart(petID, selectedDate.month, selectedDate.day, onDateSelected);
                }
                if (selectedMonth != null) {
                  _chartWidgets[2] = MonthlyChart(petID, selectedYear, selectedMonth);
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

  Future<void> _showMonthPicker(BuildContext context) async {
    final SfDateRangePicker picker = SfDateRangePicker(
      view: DateRangePickerView.year,
      selectionMode: DateRangePickerSelectionMode.range,
      onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
        if (args.value is PickerDateRange) {
          setState(() {
            selectedMonth = args.value.startDate!.month;
            selectedYear = args.value.startDate!.year;
            _chartWidgets[2] = MonthlyChart(petID, selectedYear, selectedMonth);
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
      monthCellStyle: DateRangePickerMonthCellStyle(
        todayTextStyle: TextStyle(
          color: Color.fromARGB(255, 135, 153, 239), 
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
      yearCellStyle: DateRangePickerYearCellStyle(
        todayTextStyle: TextStyle(
          color: Color.fromARGB(255, 135, 153, 239), 
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
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
                _chartWidgets[2] = MonthlyChart(petID, selectedYear, selectedMonth);
              });
              Navigator.pop(context);
            },
            child: Text("확인"),
          ),
        ],
      ),
    );
  }

  AppBar buildDetailsAppBar(BuildContext context) {
     return AppBar(
       backgroundColor: kPrimaryColor,
       elevation: 0,
       centerTitle: true,
       title: Text("혈당 차트 분석"),
       titleTextStyle: TextStyle(
         fontWeight: FontWeight.bold,
         fontSize: 22,
       ),
       leading: GestureDetector(
         onTap: () {
           Navigator.pop(context);
         },
         child: Icon(
           Icons.arrow_back_ios,
           color: Colors.white,
         ),
       ),
     );
   }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kPrimaryColor,
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
            SizedBox(height: 15),
              Container(
                height: 350,
                margin:EdgeInsets.fromLTRB(20, 0, 22, 0),
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
                      width: _selectedIndex == 0 ? 130 : _selectedIndex == 1 ? 200 : 100, 
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
                    _chartWidgets[_selectedIndex],
                  ],
                ),
              ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 20), // Adjust the padding value as needed
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "인슐린 투여 후 최저점",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: 119,
                        width: 119,
                        decoration: BoxDecoration(
                          color: Color(0xFFFFFDF3),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 21),
                              blurRadius: 60,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Stack( 
                          children: [     
                            Positioned( 
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFEE504).withOpacity(0.39), // Set the desired color for the additional container
                                  borderRadius: BorderRadius.circular(20), // Adjust the border radius as needed
                                ),
                                child: Center( 
                                  child: Text(
                                    "경계",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 19,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned( 
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 50,
                                width: 110,
                                padding: EdgeInsets.all(10),
                                child: RichText(
                                text: TextSpan(
                                  text: "150",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 19, // Set the desired font size for "150"
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "mg/dL",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16, // Set the desired font size for "mg/dL"
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                          ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 119,
                        width: 119,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 252, 231, 209),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 21),
                              blurRadius: 60,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFCC68C),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center( // Center the text within the container
                                  child: Text(
                                    "주의",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned( 
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 50,
                                width: 110,
                                padding: EdgeInsets.all(10),
                                child: RichText(
                                text: TextSpan(
                                  text: "120",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 19, // Set the desired font size for "150"
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "mg/dL",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16, // Set the desired font size for "mg/dL"
                                      ),
                                    ),
                                  ],
                              ),
                            ),
                            ),
                            ),
                          ],
                        ),
                      ),
                      // Container for "위험"
                      Container(
                        height: 119,
                        width: 119,
                        decoration: BoxDecoration(
                          color: Color(0xFFFBDBDB),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0, 21),
                              blurRadius: 60,
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 0,
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF9D9D),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Center( // Center the text within the container
                                  child: Text(
                                    "위험",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned( 
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 50,
                                width: 110,
                                padding: EdgeInsets.all(10),
                                child: RichText(
                              text: TextSpan(
                                text: "100",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 19, // Set the desired font size for "150"
                                ),
                                children: [
                                  TextSpan(
                                    text: "mg/dL",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16, // Set the desired font size for "mg/dL"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ),
                          ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.only(left: 20), // Adjust the padding value as needed
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "사료 섭취 후 기울기 변화",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 185,
                          decoration: BoxDecoration(
                            color: Color(0xFFFBDBDB),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFFF9D9D),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          child: Center(
                            child: Text("고혈당",
                            style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 17,
                                    ),
                                  ),
                          ),
                        ),
                        ),
                        Positioned( 
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 55,
                                width: 170,
                                padding: EdgeInsets.all(10),
                                child: RichText(
                              text: TextSpan(
                                text: "100",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 19, // Set the desired font size for "150"
                                ),
                                children: [
                                  TextSpan(
                                    text: "mg/dL이상 상승",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16, // Set the desired font size for "mg/dL"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            )
                          )
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          height: 120,
                          width: 185,
                          decoration: BoxDecoration(
                            color: Color(0xFFE8F4FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Color(0xFFA6D6FD),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                          child: Center(
                            child: Text("저혈당 사료/간식 섭취 시",
                            style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                      fontSize: 15,
                                    ),
                                  ),
                          ),
                        ),
                        ),
                        Positioned( 
                              bottom: 0,
                              right: 0,
                              child: Container(
                                height: 55,
                                width: 170,
                                padding: EdgeInsets.all(10),
                                child: RichText(
                              text: TextSpan(
                                text: "30",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 19, // Set the desired font size for "150"
                                ),
                                children: [
                                  TextSpan(
                                    text: "mg/dL이상 상승",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16, // Set the desired font size for "mg/dL"
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )
         ],
       ),
     );
   }
 }