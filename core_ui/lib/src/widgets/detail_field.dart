import 'package:flutter/material.dart';

import '../../core_ui.dart';

class DetailField extends StatelessWidget {
  final String label;
  final String value;

  const DetailField({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimens.PADDING_8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 22),
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}
