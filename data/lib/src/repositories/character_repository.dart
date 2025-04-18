import '../entities/character.dart';
import '../providers/character_provider.dart';

class CharacterRepository {
  final CharacterProvider _provider;

  CharacterRepository(this._provider);

  Future<(List<Result>, int)> fetchAllCharacters(
    int page, {
    String? status,
    String? species,
  }) async {
    final Map<String, dynamic> data =
        await _provider.getCharacterList(page, status, species);
    return (data['characters'] as List<Result>, data['totalPages'] as int);
  }
}
