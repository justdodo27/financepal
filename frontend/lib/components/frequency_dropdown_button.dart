import 'package:flutter/material.dart';

class FrequencyDropDownButton extends StatefulWidget {
  final String? selected;
  final Function(String frequency) onSelected;
  final List<String> frequencies;

  const FrequencyDropDownButton({
    super.key,
    required this.onSelected,
    this.selected,
    this.frequencies = const [
      'Weekly',
      'Monthly',
      'Yearly',
    ],
  });

  @override
  State<FrequencyDropDownButton> createState() =>
      _FrequencyDropDownButtonState();
}

class _FrequencyDropDownButtonState extends State<FrequencyDropDownButton> {
  late String selectedFrequency;

  @override
  void initState() {
    super.initState();
    if (widget.selected != null) {
      selectedFrequency = widget.frequencies.firstWhere(
        (freq) => freq.toUpperCase() == widget.selected,
      );
    } else {
      selectedFrequency = widget.frequencies.first;
    }
    widget.onSelected(selectedFrequency);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButton<String>(
            itemHeight: 60,
            value: selectedFrequency,
            items: widget.frequencies
                .map((freq) => DropdownMenuItem(
                      value: freq,
                      child: Text(freq),
                    ))
                .toList(),
            onChanged: (selected) {
              setState(() => selectedFrequency = selected!);
              widget.onSelected(selectedFrequency);
            },
            borderRadius: BorderRadius.circular(15.0),
            isExpanded: true,
            underline: Container(),
            style: Theme.of(context).textTheme.bodySmall,
            dropdownColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }
}
