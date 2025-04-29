import 'package:hive/hive.dart';
import 'entities/character.dart';

extension FavoritesExtension on Box<Result> {
  bool isFavorite(Result c) => values.any((Result x) => x.id == c.id);

  Future<void> toggleFavorite(Result c) async {
    final key = keys.cast<int?>().firstWhere(
          (int? k) => get(k)!.id == c.id,
          orElse: () => null,
        );
    if (key != null) {
      await delete(key);
    } else {
      await add(c);
    }
  }
}


