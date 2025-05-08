import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:core/core.dart';
import 'package:core/src/logger/logger.dart';
import 'package:data/data.dart';
import 'package:data/src/favorites_extension.dart';
import 'package:domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'character_list_event.dart';

part 'character_list_state.dart';

class CharacterListBloc extends Bloc<CharacterListEvent, CharacterListState> {
  final GetCharacterUseCase getCharacterUseCase;
  final Box<List<Result>> _characterBox;
  final Box<Result> favoriteBox;
  StreamSubscription<FavoritesUpdated>? _appEventSubscription;
  final ScrollController scrollController = ScrollController();
  final AppLogger appLogger = AppLogger();

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
    this.favoriteBox,
  ) : super(CharacterInitial()) {
    on<LoadCharactersWithFilter>(_onLoadCharactersWithFilter);
    on<ToggleFavoriteCharacter>(_onToggleFavoriteCharacter);
    on<RefreshFavorites>(_onRefreshFavorites);
    on<LoadMoreCharacters>(_onLoadMoreCharacters);

    scrollController.addListener(_onScroll);
    _appEventSubscription =
        appLocator<AppEventBus>().observe<FavoritesUpdated>((_) {
      add(RefreshFavorites());
    });
  }

  Future<bool> _hasConnection() async {
    final List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    return result != ConnectivityResult.none;
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
        !_isLoadingMore) {
      add(LoadMoreCharacters());
    }
  }

  Future<void> _onToggleFavoriteCharacter(
    ToggleFavoriteCharacter event,
    Emitter<CharacterListState> emit,
  ) async {
    await favoriteBox.toggleFavorite(event.character);

    if (state is CharacterLoaded) {
      emit(
        CharacterLoaded(
          characters: (state as CharacterLoaded).characters,
        ),
      );
    }
  }

  Future<void> _onRefreshFavorites(
    RefreshFavorites event,
    Emitter<CharacterListState> emit,
  ) async {
    if (state is CharacterLoaded) {
      emit(CharacterLoaded(
        characters: (state as CharacterLoaded).characters,
        hasReachedMax: (state as CharacterLoaded).hasReachedMax,
      ));
    }
  }

  Future<void> _onLoadMoreCharacters(
      LoadMoreCharacters event, Emitter<CharacterListState> emit) async {
    if (_isLoadingMore || state is! CharacterLoaded) return;

    final CharacterLoaded loadedState = state as CharacterLoaded;

    if (loadedState.hasReachedMax) return;
    _isLoadingMore = true;

    try {
      final (List<Result> newCharacters, int totalPages) =
          await getCharacterUseCase(
        page: currentPage,
        status: _currentStatus,
        species: _currentSpecies,
      );
      _totalPages = totalPages;

      final List<Result> updatedList = List<Result>.from(loadedState.characters)
        ..addAll(newCharacters);

      emit(CharacterLoaded(
          characters: updatedList, hasReachedMax: currentPage >= _totalPages));

      currentPage++;
    } catch (e, s) {
      appLogger.debug('❌ Error loading more:', e, s);
      emit(CharacterError(message: AppConstants.ERROR_MESSAGE));
    } finally {
      _isLoadingMore = false;
    }
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

      final List<ConnectivityResult> connectivityResult =
          await Connectivity().checkConnectivity();
      final bool isOffline =
          connectivityResult.contains(ConnectivityResult.none);

      appLogger.debug('Connectivity result: $connectivityResult');
      final String filterKey = '${event.status ?? ""}-${event.species ?? ""}';
      appLogger.debug('Available keys in Hive: ${_characterBox.keys}');

      if (isOffline) {
        final List<Result> cachedCharacters =
            _characterBox.get(filterKey, defaultValue: <Result>[]) ??
                <Result>[];

        appLogger.debug(
            'Retrieved from Hive: ${cachedCharacters.length} characters');

        if (cachedCharacters.isEmpty) {
          appLogger.debug('Loaded from cache: 0 items');
          emit(CharacterError(message: AppConstants.CHARACTER_ERROR_MESSAGE));
        } else {
          appLogger
              .debug('Loaded from cache: ${cachedCharacters.length} items');
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
        appLogger.debug(
            'Saved ${newCharacters.length} characters to cache with key: $filterKey');
      }

      if (state is CharacterLoaded && !isFilterChanged) {
        final CharacterLoaded currentState = state as CharacterLoaded;
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
      appLogger.debug('❌ Error while loading characters:', e, s);
      emit(CharacterError(message: AppConstants.ERROR_MESSAGE));
    } finally {
      _isLoadingMore = false;
    }
  }

  @override
  Future<void> close() {
    _appEventSubscription?.cancel();
    scrollController.dispose();
    return super.close();
  }
}
