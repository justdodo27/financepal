import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarData {
  final int id;
  final String name;
  final double value;
  final Color color;

  BarData({
    required this.id,
    required this.name,
    required this.value,
    required this.color,
  });
}

class BarChartSection extends StatelessWidget {
  final List<BarData> data;

  const BarChartSection({
    super.key,
    required this.data,
  });

  List<BarChartGroupData> _getGroups() {
    return data
        .map((entry) => BarChartGroupData(x: entry.id, barRods: [
              BarChartRodData(toY: entry.value, width: 6, color: entry.color)
            ]))
        .toList();
  }

  double get maxY => data.map<double>((e) => e.value).reduce(max) * 1.2;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Theme.of(context).colorScheme.onPrimary,
      child: Container(
        padding: const EdgeInsets.only(top: 20, right: 10, left: 10),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 180),
          child: BarChart(
            BarChartData(
              barGroups: _getGroups(),
              maxY: maxY,
              titlesData: FlTitlesData(
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 30,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: Text(
                        data.firstWhere((element) => element.id == value).name,
                      ),
                    ),
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: _getReservedSize(),
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(right: 3.0),
                      child: Text(
                        '${value.toInt()}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  double _getReservedSize() {
    if (maxY >= 1000) return 50.0;
    if (maxY >= 100) return 40.0;
    if (maxY >= 10) return 25.0;
    return 10.0;
  }
}
