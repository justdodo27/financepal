import 'package:flutter/material.dart';

class PieChartDetail {
  final int categoryId;
  final String categoryName;
  final double percentage;
  final double value;
  final Color color;

  PieChartDetail({
    required this.categoryId,
    required this.categoryName,
    required this.percentage,
    required this.value,
    required this.color,
  });

  factory PieChartDetail.fromJson(Map<String, dynamic> json, Color color) {
    return PieChartDetail(
      categoryId: json['category_id'],
      categoryName: json['category'],
      percentage: json['percentage'],
      value: json['value'],
      color: color,
    );
  }
}
