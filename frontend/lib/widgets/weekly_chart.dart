import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeeklyChart extends StatefulWidget {
  final int petId;
  final int startMonth;
  final int startDay;
  final int endMonth;
  final int endDay;

   WeeklyChart({
    required this.petId,
    required this.startMonth,
    required this.startDay,
    required this.endMonth,
    required this.endDay,
  });

  @override
  _WeeklyChartPageState createState() => _WeeklyChartPageState();
}

  class _WeeklyChartPageState extends State<WeeklyChart> {
  List<Map<String, dynamic>> chartData = [];
  bool isDataFetched = false;
  int lastDay = 0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void didUpdateWidget(covariant WeeklyChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startMonth != oldWidget.startMonth || widget.startDay != oldWidget.startDay || widget.endMonth != oldWidget.endMonth || widget.endDay != oldWidget.endDay) {
      fetchData();
    }
  }

  void fetchData() async {
    setState(() {
      isDataFetched = false;
    });

    var response = await http.get(Uri.parse('http://54.180.70.169/api/data/${widget.startMonth}-${widget.startDay}/${widget.endMonth}-${widget.endDay}/${widget.petId}'));
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

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(value.toInt());
    final String formattedTime =
        '${timestamp.day.toString().padLeft(2)}';
    if(timestamp.day == widget.endDay){
      if(lastDay == widget.endDay){
        lastDay = timestamp.day;
        return Text(
          "(일)",
          style: TextStyle(
            fontSize: 10,
            color: const Color.fromARGB(255, 21, 20, 20),
          ),
        );
      } else {
        lastDay = timestamp.day;
        return Text(
      formattedTime,
      style: TextStyle(
        fontSize: 9,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
      }
    } else {
      lastDay = timestamp.day;
        return Text(
      formattedTime,
      style: TextStyle(
        fontSize: 9,
        color: const Color.fromARGB(255, 21, 20, 20),
      ),
    );
    }
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    if (value.toInt() == 0) {
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
        fontSize: 10,
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
        verticalInterval: 1 * 60 * 60 * 24000 - 32500,
        ),
        borderData: FlBorderData(
          show: false
        ),
        titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 15,
            interval: 1 * 60 * 60 * 24000 - 32500, 
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
            sideTitles: SideTitles(
              showTitles: false
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false
            ),
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
              barWidth: 1.7,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Color.fromARGB(150, 135, 153, 239),
              maxContentWidth: 150,
              getTooltipItems: (List<LineBarSpot> touchedSpots) {
                return touchedSpots.map((spot) {
                  final DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                  final String timeStr = '${timestamp.day}일 ${timestamp.hour}시 ${timestamp.minute}분';
                  return LineTooltipItem('혈당: ${spot.y}\n시간: $timeStr', const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                    ),
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
