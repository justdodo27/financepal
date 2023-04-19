import 'package:flutter/material.dart';
import 'package:frontend/utils/api/category.dart';
import 'package:frontend/utils/api/payment.dart';

import 'components/home_appbar_bottom.dart';
import 'components/pie_chart_section.dart';
import 'components/bar_chart_section.dart';
import 'components/last_payments_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appBarBottomHeight = 160.0;

  String optionSelected = 'TODAY';

  final todayPieData = [
    PieData(name: 'Grocery shopping', percent: 25, color: Colors.redAccent),
    PieData(name: 'Chemical articles', percent: 20, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 15, color: Colors.blue),
    PieData(name: 'Sport', percent: 10, color: Colors.greenAccent),
    PieData(name: 'Internet', percent: 10, color: Colors.blueGrey),
    PieData(name: 'Other', percent: 5, color: Colors.grey),
  ];

  final monthPieData = [
    PieData(name: 'Grocery shopping', percent: 47.3, color: Colors.redAccent),
    PieData(
        name: 'Chemical articles', percent: 26.1, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 21.6, color: Colors.blue),
    PieData(name: 'Other', percent: 5, color: Colors.grey),
  ];

  final yearPieData = [
    PieData(name: 'Grocery shopping', percent: 48.0, color: Colors.redAccent),
    PieData(
        name: 'Chemical articles', percent: 25.0, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 12.0, color: Colors.blue),
    PieData(name: 'Other', percent: 5, color: Colors.grey),
  ];

  final todayBarData = [
    BarData(id: 0, name: '1:00 AM', value: 16.33, color: Colors.redAccent),
    BarData(id: 1, name: '2:34 AM', value: 12.23, color: Colors.redAccent),
    BarData(id: 2, name: '3:30 AM', value: 25.22, color: Colors.redAccent),
    BarData(id: 3, name: '4:00 AM', value: 16.33, color: Colors.redAccent),
    BarData(id: 4, name: '5:34 AM', value: 12.23, color: Colors.redAccent),
    BarData(id: 5, name: '6:30 AM', value: 25.22, color: Colors.redAccent),
    BarData(id: 6, name: '7:00 AM', value: 16.33, color: Colors.redAccent),
    BarData(id: 7, name: '8:34 AM', value: 12.23, color: Colors.redAccent),
    BarData(id: 8, name: '9:30 AM', value: 25.22, color: Colors.redAccent),
    BarData(id: 9, name: '10:00 AM', value: 16.33, color: Colors.redAccent),
    BarData(id: 10, name: '11:34 AM', value: 12.23, color: Colors.redAccent),
    BarData(id: 11, name: '12:30 PM', value: 25.22, color: Colors.redAccent),
    BarData(id: 12, name: '13:00 PM', value: 16.33, color: Colors.redAccent),
    BarData(id: 13, name: '14:34 PM', value: 12.23, color: Colors.redAccent),
    BarData(id: 14, name: '15:30 PM', value: 25.22, color: Colors.redAccent),
  ];

  final monthBarData = [
    BarData(id: 0, name: '01/03', value: 56.33, color: Colors.greenAccent),
    BarData(id: 1, name: '02/03', value: 22.23, color: Colors.greenAccent),
    BarData(id: 2, name: '03/03', value: 15.22, color: Colors.greenAccent),
    BarData(id: 3, name: '04/03', value: 25.62, color: Colors.greenAccent),
    BarData(id: 4, name: '05/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 5, name: '06/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 6, name: '07/03', value: 45.29, color: Colors.greenAccent),
    BarData(id: 7, name: '07/03', value: 56.33, color: Colors.greenAccent),
    BarData(id: 8, name: '08/03', value: 22.23, color: Colors.greenAccent),
    BarData(id: 9, name: '09/03', value: 15.22, color: Colors.greenAccent),
    BarData(id: 10, name: '10/03', value: 25.62, color: Colors.greenAccent),
    BarData(id: 11, name: '11/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 12, name: '12/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 13, name: '13/03', value: 45.29, color: Colors.greenAccent),
    BarData(id: 14, name: '14/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 15, name: '15/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 16, name: '16/03', value: 45.29, color: Colors.greenAccent),
    BarData(id: 17, name: '17/03', value: 56.33, color: Colors.greenAccent),
    BarData(id: 18, name: '18/03', value: 22.23, color: Colors.greenAccent),
    BarData(id: 19, name: '19/03', value: 15.22, color: Colors.greenAccent),
    BarData(id: 20, name: '20/03', value: 25.62, color: Colors.greenAccent),
    BarData(id: 21, name: '21/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 22, name: '22/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 23, name: '23/03', value: 45.29, color: Colors.greenAccent),
    BarData(id: 24, name: '24/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 25, name: '25/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 26, name: '26/03', value: 45.29, color: Colors.greenAccent),
    BarData(id: 27, name: '27/03', value: 56.33, color: Colors.greenAccent),
    BarData(id: 28, name: '28/03', value: 22.23, color: Colors.greenAccent),
    BarData(id: 29, name: '29/03', value: 15.22, color: Colors.greenAccent),
    BarData(id: 30, name: '30/03', value: 25.62, color: Colors.greenAccent),
    BarData(id: 31, name: '31/03', value: 25.62, color: Colors.greenAccent),
  ];

  final yearBarData = [
    BarData(id: 0, name: 'January', value: 560.33, color: Colors.purpleAccent),
    BarData(id: 1, name: 'February', value: 120.23, color: Colors.purpleAccent),
    BarData(id: 2, name: 'March', value: 450.22, color: Colors.purpleAccent),
    BarData(id: 3, name: 'April', value: 560.33, color: Colors.purpleAccent),
    BarData(id: 4, name: 'May', value: 120.23, color: Colors.purpleAccent),
    BarData(id: 5, name: 'June', value: 450.22, color: Colors.purpleAccent),
    BarData(id: 6, name: 'July', value: 560.33, color: Colors.purpleAccent),
    BarData(id: 7, name: 'August', value: 120.23, color: Colors.purpleAccent),
    BarData(
        id: 8, name: 'September', value: 450.22, color: Colors.purpleAccent),
    BarData(id: 9, name: 'October', value: 560.33, color: Colors.purpleAccent),
    BarData(
        id: 10, name: 'November', value: 120.23, color: Colors.purpleAccent),
    BarData(
        id: 11, name: 'December', value: 450.22, color: Colors.purpleAccent),
  ];

  final todayPayments = [
    Payment(
      id: 0,
      name: 'Test',
      type: 'BILL',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
  ];

  final monthPayments = [
    Payment(
      id: 0,
      name: 'Test',
      type: 'BILL',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
  ];

  final yearPayments = [
    Payment(
      id: 0,
      name: 'Test',
      type: 'BILL',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
  ];

  List<PieData> get pieData {
    switch (optionSelected) {
      case 'MONTH':
        return monthPieData;
      case 'YEAR':
        return yearPieData;
      default:
        return todayPieData;
    }
  }

  List<BarData> get barData {
    switch (optionSelected) {
      case 'MONTH':
        return monthBarData;
      case 'YEAR':
        return yearBarData;
      default:
        return todayBarData;
    }
  }

  List<Payment> get paymentData {
    switch (optionSelected) {
      case 'MONTH':
        return monthPayments;
      case 'YEAR':
        return yearPayments;
      default:
        return todayPayments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: appBarBottomHeight + 5), // AppBarBottom height
              PieChartSection(data: pieData),
              BarChartSection(data: barData),
              LastPaymentsSection(data: paymentData),
              const SizedBox(height: 80),
            ],
          ),
        ),
        HomeAppBarBottom(
          height: appBarBottomHeight,
          todaySpendings: 34.99,
          thisMonthSpendings: 534.81,
          thisYearSpendings: 2548.08,
          onSelectionChanged: (selected) =>
              setState(() => optionSelected = selected),
        ),
      ],
    );
  }
}
