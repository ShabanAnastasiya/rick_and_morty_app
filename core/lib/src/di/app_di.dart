import 'package:character_favorites/bloc/favorites_bloc.dart';
import 'package:character_list/bloc/character_list_bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';

import '../../core.dart';

final GetIt appLocator = GetIt.instance;

const String unauthScope = 'unauthScope';
const String authScope = 'authScope';

abstract class AppDI {
  static Future<void> initDependencies(
      GetIt locator,
      Flavor flavor,
      ) async {
    locator.registerSingleton<AppConfig>(
      AppConfig.fromFlavor(flavor),
    );

    locator.registerLazySingleton<AppEventBus>(
      AppEventBus.new,
    );

    locator.registerLazySingleton<AppEventNotifier>(
      appLocator<AppEventBus>,
    );

    locator.registerLazySingleton<AppEventObserver>(
      appLocator<AppEventBus>,
    );

    locator.registerFactory<CharacterListBloc>(
          () => CharacterListBloc(
        appLocator<GetCharacterUseCase>(),
        appLocator<DatabaseManager>().charactersBox,
        appLocator<DatabaseManager>().favoritesBox,
      ),
    );

    locator.registerFactory<FavoritesBloc>(
          () => FavoritesBloc(
        appLocator<DatabaseManager>().favoritesBox,
      ),
    );

  }
}

