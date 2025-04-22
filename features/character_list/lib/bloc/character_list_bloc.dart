import 'package:core/core.dart';
import 'package:data/src/entities/character.dart';
import 'package:domain/src/use_cases/character_list_use_case.dart';

part 'character_list_event.dart';

part 'character_list_state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final GetCharacterUseCase getCharacterUseCase;

  int currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  String? _currentStatus;
  String? _currentSpecies;

  String get selectedStatus =>
      _currentStatus ?? AppConstants.DEFAULT_CHARACTER_STATUS;

  String get selectedSpecies =>
      _currentSpecies ?? AppConstants.DEFAULT_CHARACTER_SPECIES;


  CharacterListBloc(this.getCharacterUseCase) : super(CharacterInitial()) {
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
      currentPage = 1;
      _totalPages = 1;
      _currentStatus = event.status;
      _currentSpecies = event.species;

      emit(CharacterLoading());
    }

    try {
      final int pageToLoad = event.page ?? currentPage;

      final (List<Result> newCharacters, int totalPages) =
          await getCharacterUseCase(
        page: pageToLoad,
        status: _currentStatus,
        species: _currentSpecies,
      );
      _totalPages = totalPages;

      if (state is CharacterLoaded && !isFilterChanged) {
        final CharacterLoaded currentState = state as CharacterLoaded;

        final List<Result> updatedList =
            List<Result>.from(currentState.characters)..addAll(newCharacters);

        emit(CharacterLoaded(
          characters: updatedList,
          hasReachedMax: currentPage >= _totalPages,
        ));

        currentPage = pageToLoad + 1;
      } else {
        emit(
          CharacterLoaded(
            characters: newCharacters,
            hasReachedMax: currentPage >= _totalPages,
          ),
        );

        currentPage++;
      }
    } catch (e) {
      emit(CharacterError());
    } finally {
      _isLoadingMore = false;
    }
  }
}
