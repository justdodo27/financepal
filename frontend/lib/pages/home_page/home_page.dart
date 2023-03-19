import 'package:flutter/material.dart';
import 'package:frontend/pages/settings_page/settings_page.dart';

import 'components/appbar_bottom.dart';
import '../../utils/custom_router.dart';
import 'components/pie_chart_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appBarBottomHeight = 160.0;

  final todayData = [
    Data(name: 'Grocery shopping', percent: 56.3, color: Colors.redAccent),
    Data(name: 'Chemical articles', percent: 13.1, color: Colors.purpleAccent),
    Data(name: 'Electronics', percent: 30.6, color: Colors.blue),
  ];

  final monthData = [
    Data(name: 'Grocery shopping', percent: 47.3, color: Colors.redAccent),
    Data(name: 'Chemical articles', percent: 26.1, color: Colors.purpleAccent),
    Data(name: 'Electronics', percent: 26.6, color: Colors.blue),
  ];

  final yearData = [
    Data(name: 'Grocery shopping', percent: 48.0, color: Colors.redAccent),
    Data(name: 'Chemical articles', percent: 30.0, color: Colors.purpleAccent),
    Data(name: 'Electronics', percent: 12.0, color: Colors.blue),
  ];

  String optionSelected = 'TODAY';

  List<Data> get data {
    switch (optionSelected) {
      case 'MONTH':
        return monthData;
      case 'YEAR':
        return yearData;
      default:
        return todayData;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                PieChartSection(data: data),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardTile(size: size),
                    CardTile(size: size),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardTile(size: size),
                    CardTile(size: size),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    CardTile(size: size),
                    CardTile(size: size),
                  ],
                ),
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

class CardTile extends StatelessWidget {
  const CardTile({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 4,
      color: Theme.of(context).colorScheme.onPrimary,
      child: ConstrainedBox(
        constraints:
            BoxConstraints(maxWidth: (size.width / 2) - 10, maxHeight: 200),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Hello world!',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 40,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 50,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 80,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 40,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 60,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 70,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                  Container(
                    height: 20,
                    width: 10,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
