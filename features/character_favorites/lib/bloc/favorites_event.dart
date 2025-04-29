part of 'favorites_bloc.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {

  LoadFavorites();
}

class ToggleFavorites extends FavoritesEvent {
  final Result character;

  ToggleFavorites(this.character);
}

