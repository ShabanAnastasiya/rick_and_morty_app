import 'package:flutter/material.dart';

import '../../core_ui.dart';

class CustomDropdownButton<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;
  final String Function(T) getLabel;

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
      child: DropdownButton<T>(
        value: selectedValue ?? value,
        onChanged: onChanged,
        items: items.map((T item) {
          return DropdownMenuItem<T>(
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
