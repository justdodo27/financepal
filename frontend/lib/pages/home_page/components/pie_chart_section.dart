import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../components/no_data_chart.dart';
import '../../../utils/api/models/pie_chart_detail.dart';

class PieData {
  final String name;
  final double percent;
  final Color color;

  PieData({required this.name, required this.percent, required this.color});
}

class ChartLegend extends StatelessWidget {
  final List<PieChartDetail> data;

  const ChartLegend({super.key, required this.data});

  Widget _buildIndicator(BuildContext context, Color color, String text) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: data
            .map((entry) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: _buildIndicator(
                    context,
                    entry.color,
                    entry.categoryName,
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class PieChartSection extends StatelessWidget {
  final List<PieChartDetail> data;

  const PieChartSection({
    super.key,
    required this.data,
  });

  List<PieChartSectionData> _getSections(BuildContext context) {
    return data
        .asMap()
        .map<int, PieChartSectionData>((key, data) {
          final value = PieChartSectionData(
            color: data.color,
            value: data.percentage,
            title: '${data.percentage}%',
            titleStyle: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          );
          return MapEntry(key, value);
        })
        .values
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Theme.of(context).colorScheme.onPrimary,
      child: buildPieChart(context),
    );
  }

  Widget buildPieChart(BuildContext context) {
    if (data.isEmpty) {
      return const NoDataChart();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180, maxWidth: 180),
            child: PieChart(
              PieChartData(
                sections: _getSections(context),
              ),
            ),
          ),
          ChartLegend(data: data),
        ],
      ),
    );
  }
}
