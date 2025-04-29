part of 'favorites_bloc.dart';

abstract class FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<Result> characters;

  FavoritesLoaded(this.characters);
}

class FavoritesError extends FavoritesState {
  final String message;

  FavoritesError(this.message);
}
