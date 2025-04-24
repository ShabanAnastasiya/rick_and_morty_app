import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:domain/domain.dart';
import 'package:hive/hive.dart';

part 'character_list_event.dart';

part 'character_list_state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final GetCharacterUseCase getCharacterUseCase;
  final Box _characterBox;

  int currentPage = 1;
  int _totalPages = 1;
  bool _isLoadingMore = false;
  String? _currentStatus;
  String? _currentSpecies;

  String get selectedStatus =>
      _currentStatus ?? AppConstants.DEFAULT_CHARACTER_STATUS;

  String get selectedSpecies =>
      _currentSpecies ?? AppConstants.DEFAULT_CHARACTER_SPECIES;

  CharacterListBloc(
    this.getCharacterUseCase,
    this._characterBox,
  ) : super(CharacterInitial()) {
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

      emit(CharacterLoaded(characters: []));

      emit(CharacterLoading());
    }

    try {
      final int pageToLoad = event.page ?? currentPage;

      final connectivityResult = await Connectivity().checkConnectivity();
      final bool isOffline =
          connectivityResult.contains(ConnectivityResult.none);

      ///TODO
      print('Connectivity result: $connectivityResult');
      final filterKey = '${_currentStatus ?? ""}-${_currentSpecies ?? ""}';
      print('Available keys in Hive: ${_characterBox.keys}');
      if (isOffline) {
        final cachedCharacters = _characterBox
            .get(filterKey, defaultValue: <Result>[]) as List<Result>;
        print('Retrieved from Hive: ${cachedCharacters.length} characters');

        if (cachedCharacters.isEmpty) {
          print('Loaded from cache: 0 items');
          emit(CharacterError(message: AppConstants.CHARACTER_ERROR_MESSAGE));
        } else {
          print('Loaded from cache: ${cachedCharacters.length} items');
          emit(CharacterLoaded(
            characters: cachedCharacters,
            hasReachedMax: true,
          ));
        }

        _isLoadingMore = false;
        return;
      }
      final (List<Result> newCharacters, int totalPages) =
          await getCharacterUseCase(
        page: pageToLoad,
        status: _currentStatus,
        species: _currentSpecies,
      );

      _totalPages = totalPages;

      if (pageToLoad == 1) {
        await _characterBox.put(filterKey, newCharacters.take(20).toList());
        print(
            'Saved ${newCharacters.length} characters to cache with key: $filterKey');
      }

      if (state is CharacterLoaded && !isFilterChanged) {
        final currentState = state as CharacterLoaded;
        final List<Result> updatedList =
            List<Result>.from(currentState.characters)..addAll(newCharacters);

        emit(CharacterLoaded(
          characters: updatedList,
          hasReachedMax: currentPage >= _totalPages,
        ));
      } else {
        emit(CharacterLoaded(
          characters: newCharacters,
          hasReachedMax: currentPage >= _totalPages,
        ));
      }

      currentPage = pageToLoad + 1;
    } catch (e, s) {
      print('❌ Error while loading characters: $e\n$s');
      emit(CharacterError(message: AppConstants.ERROR_MESSAGE));
    } finally {
      _isLoadingMore = false;
    }
  }
}
