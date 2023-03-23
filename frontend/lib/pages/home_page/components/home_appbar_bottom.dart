import 'package:flutter/material.dart';
import 'package:frontend/components/appbar_bottom.dart';

import '../../../components/rounded_outlined_button.dart';

class HomeAppBarBottom extends StatefulWidget {
  final double height;
  final Function(String selected) onSelectionChanged;
  final double todaySpendings;
  final double thisMonthSpendings;
  final double thisYearSpendings;

  const HomeAppBarBottom({
    super.key,
    required this.todaySpendings,
    required this.thisMonthSpendings,
    required this.thisYearSpendings,
    required this.height,
    required this.onSelectionChanged,
  });

  @override
  State<HomeAppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends State<HomeAppBarBottom> {
  late String optionSelected;

  double get spendings {
    switch (optionSelected) {
      case 'MONTH':
        return widget.thisMonthSpendings;
      case 'YEAR':
        return widget.thisYearSpendings;
      default:
        return widget.todaySpendings;
    }
  }

  @override
  void initState() {
    super.initState();
    optionSelected = 'TODAY';
  }

  @override
  Widget build(BuildContext context) {
    return AppBarBottom(
      height: widget.height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text(
                'Your spendings',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SmallRoundedOutlinedTextButton(
                    label: 'Today',
                    onPressed: () {
                      setState(() => optionSelected = 'TODAY');
                      widget.onSelectionChanged('TODAY');
                    },
                    borderColor: optionSelected == 'TODAY'
                        ? Theme.of(context).colorScheme.tertiary
                        : null,
                  ),
                  SmallRoundedOutlinedTextButton(
                    label: 'This month',
                    onPressed: () {
                      setState(() => optionSelected = 'MONTH');
                      widget.onSelectionChanged('MONTH');
                    },
                    borderColor: optionSelected == 'MONTH'
                        ? Theme.of(context).colorScheme.tertiary
                        : null,
                  ),
                  SmallRoundedOutlinedTextButton(
                    label: 'This year',
                    onPressed: () {
                      setState(() => optionSelected = 'YEAR');
                      widget.onSelectionChanged('YEAR');
                    },
                    borderColor: optionSelected == 'YEAR'
                        ? Theme.of(context).colorScheme.tertiary
                        : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
