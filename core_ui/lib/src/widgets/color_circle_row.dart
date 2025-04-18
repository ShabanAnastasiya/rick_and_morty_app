import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../core_ui.dart';

class ColorCircleRow extends StatelessWidget {
  final String text;
  final String status;

  const ColorCircleRow({
    super.key,
    required this.text,
    required this.status,
  });

  Color _getCircleColor(BuildContext context) {
    switch (status) {
      case AppConstants.DEFAULT_CHARACTER_STATUS:
        return AppColors.of(context).green;
      case AppConstants.CHARACTER_STATUS_DEAD:
        return AppColors.of(context).red;
      case AppConstants.CHARACTER_STATUS_UNKNOWN:
      default:
        return AppColors.of(context).grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 10.0,
          height: 10.0,
          decoration: BoxDecoration(
            color: _getCircleColor(context),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}
