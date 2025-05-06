import 'dart:async';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:settings/bloc/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final DatabaseManager dbManager = DatabaseManager();
  await dbManager.init();
  appLocator.registerSingleton<DatabaseManager>(dbManager);
  await _setupDI(Flavor.dev);

  runApp(const App());
}

Future<void> _setupDI(
    Flavor flavor,
    ) async {
  await AppDI.initDependencies(appLocator, flavor);
  DataDI.initDependencies(appLocator);
  DomainDI.initDependencies(appLocator);
  NavigationDI.initDependencies(appLocator);
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppRouter appRouter = appLocator<AppRouter>();

    return EasyLocalization(
      path: AppLocalization.langFolderPath,
      supportedLocales: AppLocalization.supportedLocales,
      fallbackLocale: AppLocalization.fallbackLocale,
      child: BlocProvider<SettingsCubit>(
        create: (_) => SettingsCubit()..loadTheme(),
        child: BlocBuilder<SettingsCubit, ThemeMode>(
          builder: (BuildContext context, ThemeMode themeMode) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              routerConfig: appRouter.config(),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode: themeMode,
              theme: ThemeData.light(),
              darkTheme: ThemeData.dark(),
            );
          },
        ),
      ),
    );
  }
}
