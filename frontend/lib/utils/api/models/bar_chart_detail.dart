class BarChartDetail {
  final String date;
  final double value;

  BarChartDetail({
    required this.date,
    required this.value,
  });

  factory BarChartDetail.fromJson(Map<String, dynamic> json) {
    return BarChartDetail(
      date: json['x_data'],
      value: double.tryParse(json['y_data']) ?? 0,
    );
  }
}
