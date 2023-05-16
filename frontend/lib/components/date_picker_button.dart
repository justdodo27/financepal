import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'rounded_outlined_button.dart';

class DatePickerButton extends StatefulWidget {
  final Function(DateTime selected) onDateChanged;

  const DatePickerButton({
    super.key,
    required this.onDateChanged,
  });

  @override
  State<DatePickerButton> createState() => _DatePickerButtonState();
}

class _DatePickerButtonState extends State<DatePickerButton> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    widget.onDateChanged(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return RoundedOutlinedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8),
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      onPressed: () async {
        final selected = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2223, 1, 1),
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
        setState(() => selectedDate = selected);
        widget.onDateChanged(selected);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd/MM/yyyy').format(selectedDate),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Icon(
              Icons.calendar_month,
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ],
        ),
      ),
    );
  }
}
