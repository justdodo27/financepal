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
    return Stack(
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
        Consumer<StatisticsProvider>(builder: (_, provider, __) {
          return HomeAppBarBottom(
            height: appBarBottomHeight,
            todaySpendings: provider.todayStatistics?.totalCost,
            thisMonthSpendings: provider.monthStatistics?.totalCost,
            thisYearSpendings: provider.yearStatistics?.totalCost,
            onSelectionChanged: _changeDateTimeRange,
          );
        }),
      ],
    );
  }
}
