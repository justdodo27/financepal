import 'pie_chart_data.dart';

class Statistics {
  final List<PieChartDetail> pieChartDetails;

  double get totalCost =>
      pieChartDetails.fold(0, (sum, item) => sum + item.value);

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
