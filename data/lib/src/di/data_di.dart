import 'package:core/core.dart';

import '../../data.dart';
import '../providers/character_provider.dart';
import '../repositories/character_repository.dart';

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

    locator.registerLazySingleton<ErrorHandler>(
      () => ErrorHandler(
        eventNotifier: locator<AppEventNotifier>(),
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
  }

  static void _initProviders(GetIt locator) {}

  static void _initRepositories(GetIt locator) {}
}
