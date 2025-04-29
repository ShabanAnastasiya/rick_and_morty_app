part of 'character_list_bloc.dart';

abstract class CharacterListEvent {}

class LoadCharactersWithFilter extends CharacterListEvent {
  final int? page;
  final String? status;
  final String? species;

  LoadCharactersWithFilter({
    this.page,
    this.status,
    this.species,
  });
}

class ToggleFavoriteCharacter extends CharacterListEvent {
  final Result character;

  ToggleFavoriteCharacter(this.character);
}

class RefreshFavorites extends CharacterListEvent {}
