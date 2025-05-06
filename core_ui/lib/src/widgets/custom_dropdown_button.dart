import 'package:flutter/material.dart';

import '../../core_ui.dart';

class CustomDropdownButton extends StatelessWidget {
  final String value;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final String Function(String) getLabel;

  const CustomDropdownButton({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getLabel,
    this.selectedValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.of(context).blue,
      ),
      child: DropdownButton<String>(
        value: selectedValue ?? value,
        onChanged: onChanged,
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(
              getLabel(item),
              style: TextStyle(
                fontSize: 16,
                color: AppColors.of(context).white,
              ),
            ),
          );
        }).toList(),
        dropdownColor: AppColors.of(context).blue,
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.of(context).white,
        ),
        style: TextStyle(
          color: AppColors.of(context).white,
          fontSize: 16,
        ),
      ),
    );
  }
}
