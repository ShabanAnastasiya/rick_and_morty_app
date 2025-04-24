import 'package:character_list/bloc/character_list_bloc.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:hive/hive.dart';
import '../../core.dart';

final GetIt appLocator = GetIt.instance;

const String unauthScope = 'unauthScope';
const String authScope = 'authScope';

abstract class AppDI {
  static Future<void> initDependencies(
      GetIt locator, Flavor flavor, Box<List<Result>> box) async {
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
        box as Box<List<Result>>,
      ),
    );

    locator.registerSingleton<Box>(box, instanceName: 'charactersBox');
  }
}
