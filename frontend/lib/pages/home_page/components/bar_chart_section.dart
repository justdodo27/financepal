import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../components/no_data_chart.dart';
import '../../../utils/api/models/bar_chart_detail.dart';

class BarChartSection extends StatelessWidget {
  final List<BarChartDetail> data;

  const BarChartSection({
    super.key,
    required this.data,
  });

  List<BarChartGroupData> _getGroups(BuildContext context) {
    return data
        .map((entry) => BarChartGroupData(
              x: data.indexOf(entry),
              barRods: [
                BarChartRodData(
                  toY: entry.value,
                  width: 6,
                  color: Theme.of(context).colorScheme.tertiary,
                )
              ],
            ))
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
      child: buildBarChart(context),
    );
  }

  Widget buildBarChart(BuildContext context) {
    if (data.isEmpty) {
      return const NoDataChart();
    }

    return Container(
      padding: const EdgeInsets.only(top: 20, right: 20, left: 10),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 180),
        child: BarChart(
          BarChartData(
            barGroups: _getGroups(context),
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
                    getTitlesWidget: (value, meta) {
                      if (value != 0 &&
                          value != data.length - 1 &&
                          value != data.length ~/ 2) return Container();
                      return Padding(
                        padding: const EdgeInsets.only(top: 3.0, right: 3),
                        child: Text(
                          data[value.toInt()].date,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    }),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: _getReservedSize(),
                  interval: maxY / 2,
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
    );
  }

  double _getReservedSize() {
    if (maxY >= 1000) return 50.0;
    if (maxY >= 100) return 40.0;
    if (maxY >= 10) return 25.0;
    return 10.0;
  }
}
