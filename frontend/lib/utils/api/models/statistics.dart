import 'pie_chart_data.dart';

class Statistics {
  final List<PieChartDetail> pieChartDetails;

  Statistics({
    required this.pieChartDetails,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    return Statistics(
      pieChartDetails: List<PieChartDetail>.from(
        json['pie_chart_data'].map(
          (jsonData) => PieChartDetail.fromJson(jsonData),
        ),
      ),
    );
  }
}
