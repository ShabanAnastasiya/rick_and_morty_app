import 'dart:async';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:navigation/navigation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:settings/bloc/settings_cubit.dart';
import 'error_handler/provider/app_error_handler_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(ResultAdapter());
  Hive.registerAdapter(LocationAdapter());

  final box = await Hive.openBox<List<Result>>('characters');
  print('Box opened, contains: ${box.length} items');

  ///TODO add detail
  await _setupDI(Flavor.dev, box);

  runApp(const App());
}

Future<void> _setupDI(Flavor flavor, Box<List<Result>> box) async {
  appLocator.pushNewScope(
    scopeName: unauthScope,
    init: (_) async {
      await AppDI.initDependencies(appLocator, flavor, box);
      DataDI.initDependencies(appLocator);
      DomainDI.initDependencies(appLocator);
      NavigationDI.initDependencies(appLocator);
    },
  );
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
      child: Builder(
        builder: (BuildContext context) {
          return AppErrorHandlerProvider(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => SettingsCubit()..loadTheme()),
              ],
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
        },
      ),
    );
  }
}
