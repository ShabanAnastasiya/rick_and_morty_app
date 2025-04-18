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
  final String selectedStatus;
  final String selectedSpecies;

  CharacterLoaded({
    required this.characters,
    this.hasReachedMax = false,
    this.selectedStatus = AppConstants.DEFAULT_CHARACTER_STATUS,
    this.selectedSpecies = AppConstants.DEFAULT_CHARACTER_SPECIES,
  });

  CharacterLoaded copyWith({
    List<Result>? characters,
    bool? hasReachedMax,
    String? selectedStatus,
    String? selectedSpecies,
  }) {
    return CharacterLoaded(
      characters: characters ?? this.characters,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedStatus: selectedStatus ?? this.selectedStatus,
      selectedSpecies: selectedSpecies ?? this.selectedSpecies,
    );
  }
}

class CharacterError extends CharacterListState {}
