import 'package:frontend/constant.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              isCurved: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              color : kPrimaryColor,
              barWidth: 4,
            ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> getSpots() {
    return [
      FlSpot(0, .2),
      FlSpot(1, 1.8),
      FlSpot(2, .5),
      FlSpot(3, .7),
      FlSpot(4, .3),
      FlSpot(5, 2),
      FlSpot(6, 1.5),
      FlSpot(7, 1.7),
      FlSpot(8, 9),
      FlSpot(9, 2.8),
      FlSpot(10, 2.5),
      FlSpot(11, 2.0),
    ];
  }
}
