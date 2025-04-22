import 'package:character_list/bloc/character_list_bloc.dart';
import 'package:core/core.dart';
import 'package:data/src/providers/character_provider.dart';
import 'package:data/src/repositories/character_repository.dart';
import 'package:domain/src/use_cases/character_list_use_case.dart';
import 'package:get_it/get_it.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerLazySingleton<CharacterProvider>(CharacterProvider.new);

  getIt.registerLazySingleton<CharacterRepository>(
    () => CharacterRepository(getIt()),
  );

  getIt.registerLazySingleton<GetCharacterUseCase>(
    () => GetCharacterUseCase(getIt()),
  );

  getIt.registerFactory(() => CharacterListBloc(getIt()));
}
