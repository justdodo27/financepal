import 'package:flutter/material.dart';
import 'package:frontend/providers/statistics_provider.dart';
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

  Future<void> reloadStats() async {
    try {
      await statisticsProvider.reloadStats(option: optionSelected);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
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
      onRefresh: reloadStats,
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
                final paymentData = stats.paymentStatistics;

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
