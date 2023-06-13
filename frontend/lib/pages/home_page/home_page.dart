import 'package:flutter/material.dart';
import 'package:frontend/providers/statistics_provider.dart';
import 'package:frontend/utils/api/models/category.dart';
import 'package:frontend/utils/api/models/payment.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

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

  late StatisticsProvider statisticsProvider;

  final todayPayments = [
    Payment(
      id: 0,
      name: 'Shopping at Lidl',
      type: 'BILL',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
    Payment(
      id: 1,
      name: 'Gym payment',
      type: 'BILL',
      date: DateTime.now(),
      cost: 15.99,
      category: Category(name: 'Sport'),
    ),
    Payment(
        id: 2,
        name: 'Internet bill',
        type: 'BILL',
        date: DateTime.now(),
        cost: 59.99,
        category: Category(name: 'Internet'),
        recurringPaymentId: 1),
    Payment(
      id: 3,
      name: 'Batteries for the remote control',
      type: 'BILL',
      date: DateTime.now(),
      cost: 19.99,
      category: Category(name: 'Electornics'),
    ),
  ];

  final monthPayments = [
    Payment(
      id: 0,
      name: 'Groceries',
      type: 'BILL',
      date: DateTime.now(),
      cost: 199.99,
      category: Category(name: 'Groceries'),
    ),
    Payment(
      id: 1,
      name: 'Sport',
      type: 'BILL',
      date: DateTime.now(),
      cost: 150.99,
      category: Category(name: 'Sport'),
    ),
    Payment(
      id: 2,
      name: 'Chemical areticles',
      type: 'BILL',
      date: DateTime.now(),
      cost: 59.99,
      category: Category(name: 'Chemical articles'),
    ),
    Payment(
      id: 3,
      name: 'Electornics',
      type: 'BILL',
      date: DateTime.now(),
      cost: 120.84,
      category: Category(name: 'Electornics'),
    ),
    Payment(
      id: 3,
      name: 'Sport',
      type: 'BILL',
      date: DateTime.now(),
      cost: 3.00,
      category: Category(name: 'Sport'),
    ),
  ];

  final yearPayments = [
    Payment(
      id: 0,
      name: 'Groceries',
      type: 'BILL',
      date: DateTime.now(),
      cost: 199.99,
      category: Category(name: 'Groceries'),
    ),
    Payment(
      id: 1,
      name: 'Sport',
      type: 'BILL',
      date: DateTime.now(),
      cost: 150.99,
      category: Category(name: 'Sport'),
    ),
    Payment(
      id: 2,
      name: 'Chemical areticles',
      type: 'BILL',
      date: DateTime.now(),
      cost: 59.99,
      category: Category(name: 'Chemical articles'),
    ),
    Payment(
      id: 3,
      name: 'Electornics',
      type: 'BILL',
      date: DateTime.now(),
      cost: 120.84,
      category: Category(name: 'Electornics'),
    ),
    Payment(
      id: 3,
      name: 'Sport',
      type: 'BILL',
      date: DateTime.now(),
      cost: 3.00,
      category: Category(name: 'Sport'),
    ),
  ];


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

  Future<void> getTodayStats() async {
    try {
      await statisticsProvider.getTodayStatistics();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> getMonthStats() async {
    try {
      await statisticsProvider.getMonthStatistics();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> getYearStats() async {
    try {
      await statisticsProvider.getYearStatistics();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> _changeDateTimeRange(String value) async {
    switch (value) {
      case 'MONTH':
        await getMonthStats();
        break;
      case 'YEAR':
        await getYearStats();
        break;
      default:
        await getTodayStats();
        break;
    }
    setState(() => optionSelected = value);
  }

  @override
  void initState() {
    super.initState();
    statisticsProvider =
        Provider.of<StatisticsProvider>(context, listen: false);
    getTodayStats();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.tertiary,
      onRefresh: () async =>
          await statisticsProvider.reloadStats(option: optionSelected),
      child: Stack(
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Consumer<StatisticsProvider>(
              builder: (_, provider, __) {
                if (provider.isLoading) {
                  return Column(
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height / 2),
                      Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                    ],
                  );
                }

                final stats = provider.lastFetchedStatistics!;
                final pieData = stats.pieChartDetails;
                final barData = stats.barChartDetails;

                return Column(
                  children: [
                    SizedBox(height: appBarBottomHeight + 5),
                    PieChartSection(data: pieData),
                    BarChartSection(data: barData),
                    LastPaymentsSection(data: paymentData),
                    const SizedBox(height: 80),
                  ],
                );
              },
            ),
          ),
          Consumer<StatisticsProvider>(
            builder: (_, provider, __) {
              return HomeAppBarBottom(
                height: appBarBottomHeight,
                todaySpendings: provider.getTotalCost('TODAY'),
                thisMonthSpendings: provider.getTotalCost('MONTH'),
                thisYearSpendings: provider.getTotalCost('YEAR'),
                onSelectionChanged: _changeDateTimeRange,
              );
            },
          ),
        ],
      ),
    );
  }
}
