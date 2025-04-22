import 'package:auto_route/auto_route.dart';
import 'package:character_details/detail_navigation.gm.dart';
import 'package:core/core.dart';
import 'package:core_ui/src/widgets/color_circle_row.dart';
import 'package:core_ui/src/widgets/text_pair.dart';
import 'package:data/src/entities/character.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'bloc/character_list_bloc.dart';
import 'custom_dropdown_button.dart';

@RoutePage()
class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key});

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //todo
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final CharacterListState state =
            context.read<CharacterListBloc>().state;

        if (state is CharacterLoaded && !state.hasReachedMax) {
          final bloc = context.read<CharacterListBloc>();
          context.read<CharacterListBloc>().add(
                LoadCharactersWithFilter(
                    page: bloc.currentPage,
                    status: bloc.selectedStatus,
                    species: bloc.selectedSpecies),
              );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BlocBuilder<CharacterListBloc, CharacterListState>(
                builder: (BuildContext context, CharacterListState state) {
                  final bloc = context.read<CharacterListBloc>();

                  return CustomDropdownButton(
                    value: bloc.selectedStatus,
                    items: const <String>[
                      AppConstants.DEFAULT_CHARACTER_STATUS,
                      AppConstants.CHARACTER_STATUS_DEAD,
                      AppConstants.CHARACTER_STATUS_UNKNOWN,
                    ],
                    selectedValue: bloc.selectedStatus,
                    onChanged: (String? value) {
                      context.read<CharacterListBloc>().add(
                            LoadCharactersWithFilter(
                              page: 1,
                              status: value,
                              species: bloc.selectedSpecies,
                            ),
                          );
                    },
                    getLabel: (String status) => status,
                  );
                },
              ),
              BlocBuilder<CharacterListBloc, CharacterListState>(
                builder: (BuildContext context, CharacterListState state) {
                  final bloc = context.read<CharacterListBloc>();

                  return CustomDropdownButton(
                    value: bloc.selectedSpecies,
                    items: const <String>[
                      AppConstants.DEFAULT_CHARACTER_SPECIES,
                      AppConstants.CHARACTER_SPECIES_ALIEN,
                    ],
                    selectedValue: bloc.selectedSpecies,
                    onChanged: (String? value) {
                      context.read<CharacterListBloc>().add(
                            LoadCharactersWithFilter(
                              page: 1,
                              status: bloc.selectedStatus,
                              species: value,
                            ),
                          );
                    },
                    getLabel: (String species) => species,
                  );
                },
              ),
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
                    controller: _scrollController,
                    itemCount:
                        state.characters.length + (state.hasReachedMax ? 0 : 1),
                    itemBuilder: (BuildContext context, int index) {
                      if (index >= state.characters.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final Result character = state.characters[index];
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
                            child: Row(
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
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is CharacterError) {
                  return const Center(
                    child: Text('Failed to load characters'),
                  );
                }
                return const Center(
                  child: Text('Select a page'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
