import 'package:core/core.dart';
import 'package:core/src/bloc/settings/settings_cubit.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<SettingsCubit>().state == ThemeMode.dark;

    return Column(
      children: <Widget>[
        const Text('Light/Dark Theme'),
        Switch(
          value: isDarkMode,
          onChanged: (_) {
            context.read<SettingsCubit>().toggleTheme();
          },
        ),
      ],
    );
  }
}
