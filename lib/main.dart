import 'package:character_list/bloc/character_list_bloc.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'package:settings/bloc/settings_cubit.dart';
import 'error_handler/provider/app_error_handler_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  _setupDI(Flavor.dev);

  runApp(const App());
}

void _setupDI(Flavor flavor) {
  appLocator.pushNewScope(
    scopeName: unauthScope,
    init: (_) {
      AppDI.initDependencies(appLocator, flavor);
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
                BlocProvider(
                  create:
                      (_) =>
                          appLocator<CharacterListBloc>()
                            ..add(LoadCharactersWithFilter(page: 1)),
                ),
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
