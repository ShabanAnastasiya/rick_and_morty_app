part of 'character_list_bloc.dart';

abstract class CharacterListState {}

class CharacterInitial extends CharacterListState {}

class CharacterLoading extends CharacterListState {
  final int page;

  CharacterLoading({this.page = 1});
}

class CharacterLoaded extends CharacterListState {
  final List<Result> characters;
  final bool hasReachedMax;

  CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
  });

  CharacterLoaded copyWith({
    List<Result>? characters,
    bool? hasReachedMax,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }
}

class CharacterError extends CharacterListState {
  final String message;

  CharacterError({required this.message});
}
