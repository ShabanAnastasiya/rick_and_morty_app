import 'package:core/core.dart';
import 'package:core/src/bloc/character_list/character_list_bloc.dart';
import 'package:core_ui/src/widgets/color_circle_row.dart';
import 'package:data/src/entities/character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:navigation/navigation.dart';

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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final CharacterListState state =
            context.read<CharacterListBloc>().state;
        if (state is CharacterLoaded && !state.hasReachedMax) {
          context.read<CharacterListBloc>().add(
                LoadCharactersWithFilter(
                  status: state.selectedStatus,
                  species: state.selectedSpecies,
                ),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              BlocBuilder<CharacterListBloc, CharacterListState>(
                builder: (BuildContext context, CharacterListState state) {
                  final selectedStatus = (state is CharacterLoaded)
                      ? state.selectedStatus
                      : AppConstants.DEFAULT_CHARACTER_STATUS;
                  return CustomDropdownButton(
                    value: selectedStatus,
                    items: const <String>[
                      AppConstants.DEFAULT_CHARACTER_STATUS,
                      AppConstants.CHARACTER_STATUS_DEAD,
                      AppConstants.CHARACTER_STATUS_UNKNOWN,
                    ],
                    selectedValue:
                        state is CharacterLoaded ? state.selectedStatus : null,
                    onChanged: (String? value) {
                      context.read<CharacterListBloc>().add(
                            LoadCharactersWithFilter(
                              page: 1,
                              status: value,
                              species: state is CharacterLoaded
                                  ? state.selectedSpecies
                                  : AppConstants.DEFAULT_CHARACTER_SPECIES,
                            ),
                          );
                    },
                    getLabel: (String status) => status,
                  );
                },
              ),
              BlocBuilder<CharacterListBloc, CharacterListState>(
                builder: (BuildContext context, CharacterListState state) {
                  final selectedSpecies = (state is CharacterLoaded)
                      ? state.selectedSpecies
                      : AppConstants.DEFAULT_CHARACTER_SPECIES;
                  return CustomDropdownButton(
                    value: selectedSpecies,
                    items: const <String>[
                      AppConstants.DEFAULT_CHARACTER_SPECIES,
                      AppConstants.CHARACTER_SPECIES_ALIEN,
                    ],
                    selectedValue:
                        state is CharacterLoaded ? state.selectedSpecies : null,
                    onChanged: (String? value) {
                      context.read<CharacterListBloc>().add(
                            LoadCharactersWithFilter(
                              page: 1,
                              status: state is CharacterLoaded
                                  ? state.selectedStatus
                                  : AppConstants.DEFAULT_CHARACTER_STATUS,
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
                          //=context.router.push(CharacterDetailRoute(character: character));
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
                                      _TextPair(
                                        AppConstants.LAST_KNOWN_LOCATION,
                                        character.location.name,
                                      ),
                                      const SizedBox(height: 12),
                                      _TextPair(
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

class _TextPair extends StatelessWidget {
  final String topText;
  final String bottomText;

  const _TextPair(this.topText, this.bottomText);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          topText,
          style: TextStyle(
            height: 1.5,
            color: Colors.grey.withOpacity(0.8),
          ),
        ),
        Text(bottomText),
      ],
    );
  }
}
