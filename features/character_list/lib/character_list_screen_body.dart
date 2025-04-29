import 'package:character_details/detail_navigation.gm.dart';
import 'package:character_favorites/favorites_navigation.gm.dart';
import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:data/data.dart';
import 'package:data/src/favorites_extension.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'bloc/character_list_bloc.dart';
import 'species_dropdown.dart';
import 'status_dropdown.dart';

class CharacterListScreenBody extends StatelessWidget {
  final ScrollController scrollController;

  const CharacterListScreenBody({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
   final bloc = context.read<CharacterListBloc>();

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
                child: Text(AppConstants.FAVORITES)),
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
                  controller: scrollController,
                  itemCount:
                      state.characters.length + (state.hasReachedMax ? 0 : 1),
                  itemBuilder: (BuildContext context, int index) {
                    if (index >= state.characters.length) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final Result character = state.characters[index];
                    final isFav = bloc.favoriteBox.isFavorite(character);

                    return GestureDetector(
                      onTap: () {
                        context.router
                            .push(CharacterDetailRoute(character: character));
                      },
                      child: Card(
                        margin: const EdgeInsets.all(12),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Stack(children: <Widget>[
                            Row(
                              children: <Widget>[
                                Flexible(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      character.image,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            character.name,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                          ColorCircleRow(
                                            text:
                                                '${character.status} -- ${character.species}',
                                            status: character.status,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      TextPair(
                                        AppConstants.LAST_KNOWN_LOCATION,
                                        character.location.name,
                                      ),
                                      const SizedBox(height: 12),
                                      TextPair(
                                        AppConstants.FIRST_SEEN_IN,
                                        character.origin.name,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: IconButton(
                                onPressed: () async {
                                  bloc.add(ToggleFavoriteCharacter(character));
                                },
                                icon: Icon(
                                  isFav ? Icons.star : Icons.star_border,
                                  color: Colors.purple,
                                  size: 25,
                                ),
                              ),
                            ),
                          ]),
                        ),
                      ),
                    );
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

// class CharacterCard extends StatelessWidget {
//   const CharacterCard({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.all(12),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Stack(children: <Widget>[
//           Row(
//             children: <Widget>[
//               Flexible(
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.network(
//                     character.image,
//                     width: double.infinity,
//                     height: 200,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment:
//                   CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Column(
//                       crossAxisAlignment:
//                       CrossAxisAlignment.start,
//                       children: <Widget>[
//                         Text(
//                           character.name,
//                           style:
//                           const TextStyle(fontSize: 17),
//                         ),
//                         ColorCircleRow(
//                           text:
//                           '${character.status} -- ${character.species}',
//                           status: character.status,
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 12),
//                     TextPair(
//                       AppConstants.LAST_KNOWN_LOCATION,
//                       character.location.name,
//                     ),
//                     const SizedBox(height: 12),
//                     TextPair(
//                       AppConstants.FIRST_SEEN_IN,
//                       character.origin.name,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Positioned(
//             right: 10,
//             top: 10,
//             child: GestureDetector(
//               onTap: () async {
//                 await favBox.toggleFavorite(character);
//                 (context as Element).markNeedsBuild();
//               },
//               child: Icon(
//                 isFav ? Icons.star : Icons.star_border,
//                 color: Colors.purple,
//                 size: 25,
//               ),
//             ),
//           ),
//         ]),
//       ),
//     )
//   }
// }
