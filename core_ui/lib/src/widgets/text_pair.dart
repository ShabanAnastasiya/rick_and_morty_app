import 'package:flutter/material.dart';

class TextPair extends StatelessWidget {
  final String topText;
  final String bottomText;

  const TextPair(this.topText, this.bottomText);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          topText,
          style: TextStyle(
            height: 1.5,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        Text(bottomText),
      ],
    );
  }
}