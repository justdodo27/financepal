import 'package:flutter/material.dart';
import 'package:frontend/components/date_range_picker.dart';

import '../../components/appbar_bottom.dart';
import '../../utils/api/models/category.dart';
import '../../utils/api/models/payment.dart';
import '../groups_page/groups_page.dart';
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
  final spendings = 230;
  DateTimeRange _dateTimeRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  final todayPieData = [
    PieData(name: 'Grocery shopping', percent: 25, color: Colors.redAccent),
    PieData(name: 'Chemical articles', percent: 20, color: Colors.purpleAccent),
    PieData(name: 'Electronics', percent: 15, color: Colors.blue),
    PieData(name: 'Sport', percent: 10, color: Colors.greenAccent),
    PieData(name: 'Internet', percent: 10, color: Colors.blueGrey),
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

  final todayPayments = [
    Payment(
      id: 0,
      name: 'Groceries',
      type: 'BILL',
      date: DateTime.now(),
      cost: 89.99,
      category: Category(name: 'Groceries'),
    ),
    Payment(
      id: 1,
      name: 'Gym',
      type: 'RECURRING',
      date: DateTime.now(),
      cost: 15.99,
      category: Category(name: 'Sport'),
    ),
    Payment(
      id: 2,
      name: 'Internet bill',
      type: 'RECURRING',
      date: DateTime.now(),
      cost: 59.99,
      category: Category(name: 'Internet'),
    ),
    Payment(
      id: 3,
      name: 'Batteries',
      type: 'RECURRING',
      date: DateTime.now(),
      cost: 19.99,
      category: Category(name: 'Electornics'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: appBarBottomHeight + 5), // AppBarBottom height
              PieChartSection(data: todayPieData),
              BarChartSection(data: todayBarData),
              LastPaymentsSection(data: todayPayments),
              const SizedBox(height: 80),
            ],
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
                  Text(
                    '$spendings',
                    style: Theme.of(context)
                        .textTheme
                        .apply(displayColor: Colors.white)
                        .displayLarge,
                  ),
                  const SizedBox(height: 12),
                  DateRangePicker(
                    width: MediaQuery.of(context).size.width - 70,
                    dateTimeRange: _dateTimeRange,
                    onDateTimePicked: (selected) =>
                        setState(() => _dateTimeRange = selected),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
