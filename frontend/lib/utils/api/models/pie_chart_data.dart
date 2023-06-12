import 'dart:math';

import 'package:flutter/material.dart';

class PieChartDetail {
  final int categoryId;
  final String categoryName;
  final double percentage;
  final double value;
  final Color color = Colors
      .primaries[Random().nextInt(Colors.primaries.length)]
      .withOpacity(0.6);

  PieChartDetail({
    required this.categoryId,
    required this.categoryName,
    required this.percentage,
    required this.value,
  });

  factory PieChartDetail.fromJson(Map<String, dynamic> json) {
    return PieChartDetail(
      categoryId: json['category_id'],
      categoryName: json['category'],
      percentage: json['percentage'],
      value: json['value'],
    );
  }
}
