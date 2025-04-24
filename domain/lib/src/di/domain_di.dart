import 'package:core/core.dart';
import '../../domain.dart';

abstract class DomainDI {
  static void initDependencies(GetIt locator) {
    _initUseCases(locator);
  }

  static void _initUseCases(GetIt locator) {
    locator.registerLazySingleton<GetCharacterUseCase>(
          () => GetCharacterUseCase(locator()),
    );
  }
}
