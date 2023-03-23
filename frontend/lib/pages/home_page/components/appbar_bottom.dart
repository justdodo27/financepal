import 'package:flutter/material.dart';

import '../../../components/rounded_outlined_button.dart';

class AppBarBottom extends StatefulWidget {
  final double height;
  final Function(String selected) onSelectionChanged;
  final double todaySpendings;
  final double thisMonthSpendings;
  final double thisYearSpendings;

  const AppBarBottom({
    super.key,
    required this.todaySpendings,
    required this.thisMonthSpendings,
    required this.thisYearSpendings,
    required this.height,
    required this.onSelectionChanged,
  });

  @override
  State<AppBarBottom> createState() => _AppBarBottomState();
}

class _AppBarBottomState extends State<AppBarBottom> {
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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: widget.height),
      child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  '$spendings',
                  style: Theme.of(context)
                      .textTheme
                      .apply(displayColor: Colors.white)
                      .displayLarge,
                ),
                Text(
                  'Money spent',
                  style: Theme.of(context)
                      .textTheme
                      .apply(bodyColor: Colors.white)
                      .bodyLarge,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SmallRoundedOutlinedButton(
                      label: 'Today',
                      onPressed: () {
                        setState(() => optionSelected = 'TODAY');
                        widget.onSelectionChanged('TODAY');
                      },
                      borderColor: optionSelected == 'TODAY'
                          ? Theme.of(context).colorScheme.tertiary
                          : null,
                    ),
                    SmallRoundedOutlinedButton(
                      label: 'This month',
                      onPressed: () {
                        setState(() => optionSelected = 'MONTH');
                        widget.onSelectionChanged('MONTH');
                      },
                      borderColor: optionSelected == 'MONTH'
                          ? Theme.of(context).colorScheme.tertiary
                          : null,
                    ),
                    SmallRoundedOutlinedButton(
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
      ),
    );
  }
}
