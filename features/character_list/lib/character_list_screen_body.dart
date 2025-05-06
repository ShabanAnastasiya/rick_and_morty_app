import 'package:character_details/detail_navigation.gm.dart';
import 'package:character_favorites/favorites_navigation.gm.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data/data.dart';
import 'package:data/src/favorites_extension.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'bloc/character_list_bloc.dart';
import 'dropdown/species_dropdown.dart';
import 'dropdown/status_dropdown.dart';

class CharacterListScreenBody extends StatelessWidget {
  const CharacterListScreenBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final CharacterListBloc bloc = context.read<CharacterListBloc>();
    final ScrollController controller = bloc.scrollController;

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            const StatusDropdown(),
            const SpeciesDropdown(),
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
    );
  }
}
