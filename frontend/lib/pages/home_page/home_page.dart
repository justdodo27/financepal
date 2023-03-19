import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page/settings_page.dart';

import 'components/appbar_bottom.dart';
import '../../utils/custom_router.dart';
import 'components/bar_chart_section.dart';
import 'components/pie_chart_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appBarBottomHeight = 160.0;

  final todayPieData = [
    PieData(name: 'Grocery shopping', percent: 56.3, color: Colors.redAccent),
    PieData(
        name: 'Chemical articles', percent: 13.1, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 30.6, color: Colors.blue),
  ];

  final monthPieData = [
    PieData(name: 'Grocery shopping', percent: 47.3, color: Colors.redAccent),
    PieData(
        name: 'Chemical articles', percent: 26.1, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 26.6, color: Colors.blue),
  ];

  final yearPieData = [
    PieData(name: 'Grocery shopping', percent: 48.0, color: Colors.redAccent),
    PieData(
        name: 'Chemical articles', percent: 30.0, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 12.0, color: Colors.blue),
  ];

  final todayBarData = [
    BarData(id: 0, name: '1:00 PM', value: 16.33, color: Colors.redAccent),
    BarData(id: 1, name: '2:34 PM', value: 12.23, color: Colors.redAccent),
    BarData(id: 2, name: '8:30 PM', value: 25.22, color: Colors.redAccent),
  ];

  final monthBarData = [
    BarData(id: 0, name: '01/03', value: 56.33, color: Colors.greenAccent),
    BarData(id: 1, name: '02/03', value: 22.23, color: Colors.greenAccent),
    BarData(id: 2, name: '03/03', value: 15.22, color: Colors.greenAccent),
    BarData(id: 3, name: '04/03', value: 25.62, color: Colors.greenAccent),
    BarData(id: 4, name: '05/03', value: 35.27, color: Colors.greenAccent),
    BarData(id: 5, name: '06/03', value: 55.52, color: Colors.greenAccent),
    BarData(id: 6, name: '07/03', value: 45.29, color: Colors.greenAccent),
  ];

  final yearBarData = [
    BarData(id: 0, name: 'January', value: 560.33, color: Colors.purpleAccent),
    BarData(id: 1, name: 'February', value: 120.23, color: Colors.purpleAccent),
    BarData(id: 2, name: 'March', value: 450.22, color: Colors.purpleAccent),
  ];

  String optionSelected = 'TODAY';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          splashRadius: 25,
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            splashRadius: 25,
            icon: const Icon(Icons.settings),
            onPressed: () => CustomRouter.push(
              context: context,
              page: const SettingsPage(),
              animation: RouterAnimation.rightToLeft,
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(height: appBarBottomHeight + 5), // AppBarBottom height
                PieChartSection(data: pieData),
                BarChartSection(data: barData),
              ],
            ),
          ),
          AppBarBottom(
            height: appBarBottomHeight,
            todaySpendings: 34.99,
            thisMonthSpendings: 534.81,
            thisYearSpendings: 2548.08,
            onSelectionChanged: (selected) =>
                setState(() => optionSelected = selected),
          ),
        ],
      ),
    );
  }
}
