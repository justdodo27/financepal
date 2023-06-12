import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../components/appbar_bottom.dart';
import '../../../components/rounded_outlined_button.dart';
import '../../../themes/theme_manager.dart';

class HomeAppBarBottom extends StatefulWidget {
  final double height;
  final Function(String selected) onSelectionChanged;
  final double? todaySpendings;
  final double? thisMonthSpendings;
  final double? thisYearSpendings;

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

  String? get spendings {
    switch (optionSelected) {
      case 'MONTH':
        return widget.thisMonthSpendings?.toStringAsFixed(2);
      case 'YEAR':
        return widget.thisYearSpendings?.toStringAsFixed(2);
      default:
        return widget.todaySpendings?.toStringAsFixed(2);
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
          Consumer<ThemeManager>(
            builder: (context, theme, child) => Column(
              children: [
                Text(
                  'Your spendings',
                  style: Theme.of(context)
                      .textTheme
                      .apply(
                        bodyColor: theme.isDark ? Colors.white : Colors.black,
                      )
                      .bodyLarge,
                ),
                if (spendings != null)
                  Text(
                    '$spendings',
                    style: Theme.of(context)
                        .textTheme
                        .apply(
                          displayColor:
                              theme.isDark ? Colors.white : Colors.black,
                        )
                        .displayLarge,
                  ),
                if (spendings == null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
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
                      label: 'Last month',
                      onPressed: () {
                        setState(() => optionSelected = 'MONTH');
                        widget.onSelectionChanged('MONTH');
                      },
                      borderColor: optionSelected == 'MONTH'
                          ? Theme.of(context).colorScheme.tertiary
                          : null,
                    ),
                    SmallRoundedOutlinedTextButton(
                      label: 'Last year',
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
          ),
        ],
      ),
    );
  }
}
