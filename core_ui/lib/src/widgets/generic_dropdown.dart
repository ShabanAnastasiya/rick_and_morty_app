import 'package:flutter/material.dart';

import '../../core_ui.dart';

class GenericDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T selectedValue;
  final String Function(T) getLabel;
  final void Function(T?) onChanged;

  const GenericDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.getLabel,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdownButton<T>(
      value: selectedValue,
      items: items,
      selectedValue: selectedValue,
      onChanged: onChanged,
      getLabel: getLabel,
    );
  }
}
