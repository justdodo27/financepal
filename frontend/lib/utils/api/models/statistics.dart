import 'package:frontend/utils/api/models/payment_statistics.dart';

import '../../../themes/theme_constants.dart';
import 'bar_chart_detail.dart';
import 'pie_chart_detail.dart';

class Statistics {
  final List<PieChartDetail> pieChartDetails;
  final List<BarChartDetail> barChartDetails;
  final List<PaymentStatistics> paymentStatistics;

  Statistics({
    required this.pieChartDetails,
    required this.barChartDetails,
    required this.paymentStatistics,
  });

  factory Statistics.fromJson(Map<String, dynamic> json) {
    final pieChartData = json['pie_chart_data'].asMap().entries.map((entry) {
      final color = getPieChartColor(entry.key);
      return PieChartDetail.fromJson(entry.value, color);
    });

    return Statistics(
      pieChartDetails: List<PieChartDetail>.from(pieChartData),
      barChartDetails: List<BarChartDetail>.from(
        json['plot_data'].map(
          (jsonData) => BarChartDetail.fromJson(jsonData),
        ),
      ),
      paymentStatistics: List<PaymentStatistics>.from(
        json['payments_list'].map(
          (jsonData) => PaymentStatistics.fromJson(jsonData),
        ),
      ),
    );
  }
}
