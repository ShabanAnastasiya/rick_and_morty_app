import 'package:flutter/material.dart';

abstract class AppColors {
  factory AppColors.of(BuildContext context) {
    final Brightness brightness = Theme.of(context).brightness;
    return brightness == Brightness.light
        ? const LightColors()
        : const DarkColors();
  }

  Color get primaryBg;

  Color get white;

  Color get green;

  Color get red;

  Color get grey;

  Color get blue;
}

class DarkColors extends LightColors {
  const DarkColors();

  @override
  Color get green => const Color(0xFF2D8A3A);

  @override
  Color get red => const Color(0xFFB71C1C);

  @override
  Color get grey => const Color(0xFF616161);

  @override
  Color get blue => const Color(0xFF0091D3);
}

class LightColors implements AppColors {
  const LightColors();

  @override
  // RGBO(236, 239, 241, 1)
  Color get primaryBg => const Color(0xFFeceff1);

  @override
  Color get white => const Color.fromRGBO(255, 255, 255, 1);

  @override
  Color get green => const Color(0xFF4CAF50);

  @override
  Color get red => const Color(0xFFD32F2F);

  @override
  Color get grey => const Color(0xFFB0BEC5);

  @override
  Color get blue => const Color(0xFF00B0FF);
}
