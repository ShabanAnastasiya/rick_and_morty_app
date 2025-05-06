import 'package:character_details/detail_navigation.gm.dart';
import 'package:character_favorites/favorites_navigation.gm.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data/data.dart';
import 'package:data/src/favorites_extension.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import '../bloc/character_list_bloc.dart';

class CharacterListScreenBody extends StatelessWidget {
  const CharacterListScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CharacterListBloc bloc = context.read<CharacterListBloc>();
    final ScrollController controller = bloc.scrollController;

    return BlocBuilder<CharacterListBloc, CharacterListState>(
        builder: (BuildContext context, CharacterListState state) {
      final CharacterListBloc bloc = context.read<CharacterListBloc>();

      return
        Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GenericDropdown<String>(
                items: const <String>[
                  AppConstants.DEFAULT_CHARACTER_STATUS,
                  AppConstants.CHARACTER_STATUS_DEAD,
                  AppConstants.CHARACTER_STATUS_UNKNOWN,
                ],
                selectedValue: bloc.selectedStatus,
                getLabel: (String s) => s,
                onChanged: (String? value) {
                  context.read<CharacterListBloc>().add(
                        LoadCharactersWithFilter(
                          page: 1,
                          status: value,
                          species: bloc.selectedSpecies,
                        ),
                      );
                },
              ),
              GenericDropdown<String>(
                items: const <String>[
                  AppConstants.DEFAULT_CHARACTER_SPECIES,
                  AppConstants.CHARACTER_SPECIES_ALIEN,
                ],
                selectedValue: bloc.selectedSpecies,
                getLabel: (String s) => s,
                onChanged: (String? value) {
                  context.read<CharacterListBloc>().add(
                        LoadCharactersWithFilter(
                          page: 1,
                          status: bloc.selectedStatus,
                          species: value,
                        ),
                      );
                },
              ),
              ElevatedButton(
                  onPressed: () {
                    context.router.push(const FavoritesRoute());
                  },
                  child: const Text(AppConstants.FAVORITES)),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<CharacterListBloc, CharacterListState>(
              builder: (BuildContext context, CharacterListState state) {
                if (state is CharacterLoading && state.page == 1) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is CharacterLoaded) {
                  return ListView.builder(
                    controller: controller,
                    itemCount:
                        state.characters.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= state.characters.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final Result character = state.characters[index];
                      final bool isFav = bloc.favoriteBox.isFavorite(character);

                      return CharacterCard(
                          character: character,
                          isFav: isFav,
                          onFavoriteToggle: () {
                            bloc.add(ToggleFavoriteCharacter(character));
                          },
                          onTap: () {
                            context.router
                                .push(CharacterDetailRoute(character: character));
                          });
                    },
                  );
                } else if (state is CharacterError) {
                  return NoConnectionScreen(
                    onRetry: () {
                      context.read<CharacterListBloc>().add(
                            LoadCharactersWithFilter(page: 1),
                          );
                    },
                  );
                }
                return const Center(
                  child: Text(AppConstants.SELECT_PAGE),
                );
              },
            ),
          ),
        ],
      );}
    );
  }
}
