import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'rounded_outlined_button.dart';

class DateRangePicker extends StatelessWidget {
  final DateTimeRange dateTimeRange;
  final Function(DateTimeRange selected) onDateTimePicked;
  final EdgeInsets padding;
  final double? width;

  const DateRangePicker({
    super.key,
    required this.dateTimeRange,
    required this.onDateTimePicked,
    this.padding = const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
    this.width,
  });

  DateTimeRange _processRange(DateTimeRange range) => DateTimeRange(
        start: range.start,
        end: range.end
            .add(const Duration(days: 1))
            .subtract(const Duration(seconds: 1)),
      );

  @override
  Widget build(BuildContext context) {
    return RoundedOutlinedButton(
      backgroundColor: Theme.of(context).colorScheme.onPrimary,
      borderColor: Colors.grey,
      onPressed: () async {
        DateTimeRange? selected = await showDateRangePicker(
          context: context,
          initialDateRange: dateTimeRange,
          firstDate: DateTime(2023, 1),
          lastDate: DateTime.now(),
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Theme.of(context).colorScheme.tertiary,
                    ),
              ),
              child: child!,
            );
          },
        );
        if (selected == null) return;
        final processed = _processRange(selected);
        onDateTimePicked(processed);
      },
      width: width ?? 100.0,
      padding: padding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: SizedBox(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Icon(
                Icons.calendar_month,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
              Text(
                '${DateFormat('dd.MM.yyyy').format(dateTimeRange.start)} - ${DateFormat('dd.MM.yyyy').format(dateTimeRange.end)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Icon(
                Icons.edit,
                color: Theme.of(context).textTheme.bodySmall!.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
