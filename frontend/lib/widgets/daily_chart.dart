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
        
        if (jsonData['time_range_data_list'] is List<dynamic>) {
          List<dynamic> dataList = jsonData['time_range_data_list'];

          List<Map<String, dynamic>> validDataList = dataList.where((item) {
            final timestamp = item['timestamp'] as String?;
            final bloodsugar = item['bloodsugar'] as int?;

            return timestamp != null && bloodsugar != null;
          }).map((item) {
            final timestamp = item['timestamp'] as String;
            final bloodsugar = item['bloodsugar'] as int;

            return {
              'timestamp': DateTime.parse(timestamp),
              'bloodsugar': bloodsugar,
            };
          }).toList();

          setState(() {
            chartData = validDataList;
          });
        } else {
          print('Invalid response format: "time_range_data_list" is not a List');
        }
      } catch (e) {
        print('Error parsing response data: $e');
      }
    } else {
      print('Error fetching data. Status Code: ${response.statusCode}');
    }
  }

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
              color: kPrimaryColor,
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }
}