import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:data/src/favorites_extension.dart';
import 'package:hive/hive.dart';

part 'favorites_event.dart';

part 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final Box<Result> favoriteBox;

  FavoritesBloc(this.favoriteBox) : super(FavoritesLoading()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorites>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final List<Result> favorites = favoriteBox.values.toList();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(AppConstants.ERROR_MESSAGE));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorites event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      await favoriteBox.toggleFavorite(event.character);

      appLocator<AppEventNotifier>().notify(FavoritesUpdated());

      final List<Result> updatedFavorites = favoriteBox.values.toList();
      emit(FavoritesLoaded(updatedFavorites));
    } catch (e) {
      emit(FavoritesError(AppConstants.ERROR_MESSAGE));
    }
  }
}
