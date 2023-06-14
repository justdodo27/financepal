import 'package:flutter/material.dart';
import 'package:frontend/utils/snackbars.dart';
import 'package:provider/provider.dart';

import '../../components/appbar_bottom.dart';
import '../../components/date_range_picker.dart';
import '../../components/pdf_viewer.dart';
import '../../providers/statistics_provider.dart';
import '../../utils/api/models/group.dart';
import '../home_page/components/bar_chart_section.dart';
import '../home_page/components/last_payments_section.dart';
import '../home_page/components/pie_chart_section.dart';

class ReportsPage extends StatefulWidget {
  final Group? group;
  const ReportsPage({super.key, this.group});

  @override
  State<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final appBarBottomHeight = 160.0;
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  @override
  void initState() {
    super.initState();
    _getInitialData();
  }

  void _getInitialData() async {
    try {
      await Provider.of<StatisticsProvider>(context, listen: false)
          .getTodayStatistics();
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  void _onDateRangeChanged(DateTimeRange newRange) async {
    setState(() => _dateTimeRange = newRange);
    try {
      await Provider.of<StatisticsProvider>(context, listen: false)
          .getStatistics(_dateTimeRange);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<void> reloadStats() async {
    try {
      await Provider.of<StatisticsProvider>(context, listen: false)
          .getStatistics(_dateTimeRange);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
  }

  Future<String?> getReportUrl() async {
    try {
      return await Provider.of<StatisticsProvider>(context, listen: false)
          .getReportUrl(_dateTimeRange);
    } on Exception catch (e) {
      showExceptionSnackBar(context, e);
    }
    return null;
  }

  void _downloadReport(String url) async => Navigator.push(
        context,
        MaterialPageRoute<dynamic>(
          builder: (_) => PDFViewerFromUrl(
            url: url,
          ),
        ),
      );

  Future<dynamic> _showDownloadDialog() async {
    final url = await getReportUrl();
    if (!mounted) return;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          'Do you want to download the report?',
          style: Theme.of(context).textTheme.displayMedium,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (url != null) {
                _downloadReport(url);
              }
            },
            child: Text(
              'Yes',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'No',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
                        SizedBox(
                            height: MediaQuery.of(context).size.height / 2),
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
            AppBarBottom(
              height: appBarBottomHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Text(
                        widget.group != null
                            ? '${widget.group!.name} spendings'
                            : 'Your spendings',
                        style: Theme.of(context)
                            .textTheme
                            .apply(bodyColor: Colors.white)
                            .bodyLarge,
                      ),
                      Consumer<StatisticsProvider>(
                        builder: (context, provider, child) {
                          final spendings =
                              provider.getTotalCost('LAST')?.toStringAsFixed(2);

                          if (spendings == null) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                              ),
                            );
                          }

                          return Text(
                            spendings,
                            style: Theme.of(context)
                                .textTheme
                                .apply(displayColor: Colors.white)
                                .displayLarge,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      DateRangePicker(
                        width: MediaQuery.of(context).size.width - 70,
                        dateTimeRange: _dateTimeRange,
                        onDateTimePicked: _onDateRangeChanged,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Opacity(
        opacity: 0.85,
        child: FloatingActionButton(
          heroTag: null,
          onPressed: _showDownloadDialog,
          child: Icon(
            Icons.download,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ),
    );
  }
}
