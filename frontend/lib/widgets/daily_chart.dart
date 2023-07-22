import 'package:frontend/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DailyChart extends StatefulWidget {
  final int petId;

  DailyChart(this.petId);

  @override
  _DailyChartPageState createState() => _DailyChartPageState();
}

class _DailyChartPageState extends State<DailyChart> {
  List<Map<String, dynamic>> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var response = await http.get(Uri.parse('http://54.180.70.169/api/data/one-day/${widget.petId}'));

    if (response.statusCode == 200) {
      try {
        dynamic jsonData = json.decode(response.body);
        print('jsonData: $jsonData');

        if (jsonData['data_list'] is List<dynamic>) {
          List<dynamic> dataList = jsonData['data_list'];

          List validDataList = dataList.expand((item) {
            final date = item['date'] as String?;
            final data = item['data'] as List<dynamic>?;
            
            if (date != null && data != null && data.isNotEmpty) {
              return data.map((innerItem) {
                final timestamp = innerItem['timestamp'] as String;
                final bloodsugar = innerItem['bloodsugar'] as int?;

                if (bloodsugar != null) {
                  return {
                    'timestamp': DateTime.parse(timestamp),
                    'bloodsugar': bloodsugar,
                  };
                }
                return null;
              }).whereType<Map<String, dynamic>>().toList();
            }

            return [];
          }).toList();

          setState(() {
            chartData = validDataList.cast<Map<String, dynamic>>(); // 타입 캐스팅 추가
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

  final double lowerValue = 80.0;
  final double upperValue = 120.0;
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
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
              barWidth: 4,
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueAccent,
              ),   
           ),
         ),
       ),
    );
  }
}