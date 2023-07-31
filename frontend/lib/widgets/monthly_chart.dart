import 'package:frontend/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';

class MonthlyChart extends StatefulWidget {
  final int petId;
  final int selectedYear;
  final int selectedMonth;

  MonthlyChart(this.petId, this.selectedYear, this.selectedMonth);

  @override
  _MonthlyChartPageState createState() => _MonthlyChartPageState();
}

class _MonthlyChartPageState extends State<MonthlyChart> {
  List<Map<String, dynamic>> chartData = [];
  bool isDataFetched = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant MonthlyChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedMonth != oldWidget.selectedMonth) {
      fetchData();
    }
  }

  void fetchData() async {
    setState(() {
      isDataFetched = false;
    });


    var response = await http.get(Uri.parse('http://54.180.70.169/api/data/${widget.selectedMonth}/${widget.petId}'));
    if (response.statusCode == 200) {
      try {
        dynamic jsonData = json.decode(response.body);
        print(json.decode(response.body));

        if (jsonData['data_list'] is List<dynamic>) {
          List<dynamic> dataList = jsonData['data_list'];

          List<Map<String, dynamic>> validDataList = dataList
              .where((item) => item['bloodsugar'] != null)
              .map<Map<String, dynamic>>((item) {
                final timestamp = item['timestamp'] as String;
                final bloodsugar = item['bloodsugar'] as int;
                return {
                  'timestamp': DateTime.parse(timestamp),
                  'bloodsugar': bloodsugar,
                };
              })
              .toList();

          setState(() {
            chartData = validDataList;
            isDataFetched = true;
          });
        } else {
          print('Invalid response format: "data_list" is not a List');
        }
      } catch (e) {
        print('Error parsing response data: $e');
      }
    } else {
      print('Error fetching data. Status Code: ${response.statusCode}');
    }
}

int calculateWeekNumber(DateTime startDate, DateTime currentDate) {
  DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
  int weeksPassed = (currentDate.difference(firstDayOfMonth).inDays ~/ 7) + 1;
  return weeksPassed;
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  final timestamp = DateTime.fromMillisecondsSinceEpoch(value.toInt());
  int weekNumber = calculateWeekNumber(DateTime(timestamp.year, timestamp.month, 1), timestamp);

  if (weekNumber >= 1 && weekNumber <= 4) {
    return Text(
      "$weekNumber",
      style: TextStyle(
        fontSize: 10,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
  } else {
    return Text(
      "(주)",
      style: TextStyle(
        fontSize: 10,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
  }
}

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() == 1) {
      return Text('');
    }
    if (value.toInt() == 200) {
      return Text(
      '(mg/dL)',
      style: TextStyle(
        fontSize: 9,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
    }
    return Text(
      '${value.toInt()}',
      style: TextStyle(
        fontSize: 9,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isDataFetched) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return AspectRatio(
      aspectRatio: 1.4,
      child: Stack(
        children: [
          BelowLineToFill(
            startY: 93,
            endY: 140,
            fillColor: Color.fromARGB(255, 135, 153, 239).withOpacity(0.3),
          ),
      LineChart(
      LineChartData(
        minY: 0,
        maxY: 200,
        gridData: FlGridData(show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        checkToShowHorizontalLine : showAllGrids,
        horizontalInterval: 40,
        verticalInterval: 1 * 60 * 60 * 24000 * 7,
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 15,
            interval: 1 * 60 * 60 * 24000 * 7, 
            getTitlesWidget: bottomTitleWidgets, 
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            interval: 40,
            getTitlesWidget: leftTitleWidgets,
          ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
          lineBarsData: [
            LineChartBarData(
              spots: chartData.map((data) {
                final timestamp = data['timestamp'] as DateTime;
                final bloodsugar = data['bloodsugar'] as int;
                return FlSpot(timestamp.millisecondsSinceEpoch.toDouble(), bloodsugar.toDouble());
              }).toList(),
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              color: Color.fromARGB(255, 135, 153, 239),
              barWidth: 1.4,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Color.fromARGB(200, 135, 153, 239),
              maxContentWidth: 150,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  final String timeStr = '${timestamp.day}일 ${timestamp.hour}시 ${timestamp.minute}분';
                  return LineTooltipItem('혈당: ${spot.y}\n시간: $timeStr', 
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                    )
                  );
                }).toList();
                 },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BelowLineToFill extends StatelessWidget {
  final double startY;
  final double endY;
  final Color fillColor;

  BelowLineToFill({
    required this.startY,
    required this.endY,
    required this.fillColor,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipPath(
        clipper: _BelowLineToFillClipper(startY, endY),
        child: Container(color: fillColor),
      ),
    );
  }
}

class _BelowLineToFillClipper extends CustomClipper<Path> {
  final double startY;
  final double endY;

  _BelowLineToFillClipper(this.startY, this.endY);

  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(34, startY);
    path.lineTo(size.width, startY);
    path.lineTo(size.width, endY);
    path.lineTo(34, endY);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_BelowLineToFillClipper oldClipper) => true;
}