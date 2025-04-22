import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'bloc/settings_cubit.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<SettingsCubit>().state == ThemeMode.dark;

    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Text(AppConstants.SETTINGS_SCREEN_TITLE),
          const SizedBox(height: 10),
          Switch(
            value: isDarkMode,
            onChanged: (_) {
              context.read<SettingsCubit>().toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
