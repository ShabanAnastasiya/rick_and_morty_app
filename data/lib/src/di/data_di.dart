import 'package:core/core.dart';

import '../../data.dart';
import '../providers/character_provider.dart';

abstract class DataDI {
  static void initDependencies(GetIt locator) {
    _initApi(locator);
    _initProviders(locator);
    _initRepositories(locator);
  }

  static void _initApi(GetIt locator) {
    locator.registerLazySingleton<DioConfig>(
      () => DioConfig(
        appConfig: locator<AppConfig>(),
      ),
    );

    locator.registerLazySingleton<ApiProvider>(
      () => ApiProvider(
        locator<DioConfig>().dio,
      ),
    );

    locator.registerLazySingleton<CharacterProvider>(
      CharacterProvider.new,
    );

    locator.registerLazySingleton<CharacterRepository>(
      () => CharacterRepository(locator()),
    );

    locator.registerLazySingleton<AppEventBus>(
      AppEventBus.new,
    );

    locator.registerLazySingleton<AppEventNotifier>(
      locator<AppEventBus>,
    );

    locator.registerLazySingleton<AppEventObserver>(
      locator<AppEventBus>,
    );
  }

  static void _initProviders(GetIt locator) {}

  static void _initRepositories(GetIt locator) {}
}
