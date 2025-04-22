import 'package:data/src/entities/character.dart';
import 'package:data/src/repositories/character_repository.dart';

class GetCharacterUseCase {
  final CharacterRepository repository;

  GetCharacterUseCase(this.repository);

  Future<(List<Result>, int)> call({
    required int page,
    String? status,
    String? species,
  }) {
    return repository.fetchAllCharacters(
      page,
      status: status,
      species: species,
    );
  }
}
