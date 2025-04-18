import 'package:bloc/bloc.dart';
import 'package:data/src/entities/character.dart';
import 'package:data/src/repositories/character_repository.dart';
import '../../../core.dart';

part 'character_list_event.dart';

part 'character_list_state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final CharacterRepository repository;
  int _currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  String? _currentStatus;
  String? _currentSpecies;

  CharacterListBloc(this.repository) : super(CharacterInitial()) {
    on<LoadCharactersWithFilter>(_onLoadCharactersWithFilter);
  }

  Future<void> _onLoadCharactersWithFilter(
    LoadCharactersWithFilter event,
    Emitter<CharacterListState> emit,
  ) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    final bool isFilterChanged =
        event.status != _currentStatus || event.species != _currentSpecies;

    if (isFilterChanged) {
      _currentPage = 1;
      _totalPages = 1;
      _currentStatus = event.status;
      _currentSpecies = event.species;

      emit(CharacterLoading());
    }

    try {
      final int pageToLoad = event.page ?? _currentPage;

      final (List<Result> newCharacters, int totalPages) =
          await repository.fetchAllCharacters(
        pageToLoad,
        status: _currentStatus,
        species: _currentSpecies,
      );
      _totalPages = totalPages;

      if (state is CharacterLoaded && !isFilterChanged) {
        final currentState = state as CharacterLoaded;

        final updatedList = List<Result>.from(currentState.characters)
          ..addAll(newCharacters);

        emit(CharacterLoaded(
          characters: updatedList,
          hasReachedMax: _currentPage >= _totalPages,
          selectedStatus:
              _currentStatus ?? AppConstants.DEFAULT_CHARACTER_STATUS,
          selectedSpecies:
              _currentSpecies ?? AppConstants.DEFAULT_CHARACTER_SPECIES,
        ));

        _currentPage = pageToLoad + 1;
      } else {
        emit(
          CharacterLoaded(
            characters: newCharacters,
            hasReachedMax: _currentPage >= _totalPages,
            selectedStatus:
                _currentStatus ?? AppConstants.DEFAULT_CHARACTER_STATUS,
            selectedSpecies:
                _currentSpecies ?? AppConstants.DEFAULT_CHARACTER_SPECIES,
          ),
        );

        _currentPage++;
      }
    } catch (e) {
      emit(CharacterError());
    } finally {
      _isLoadingMore = false;
    }
  }
}
