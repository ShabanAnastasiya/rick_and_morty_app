import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/character_list_bloc.dart';

void setupCharacterScrollListener({
  required ScrollController controller,
  required BuildContext context,
}) {
  controller.addListener(() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      final CharacterListState state = context.read<CharacterListBloc>().state;

      if (state is CharacterLoaded && !state.hasReachedMax) {
        final CharacterListBloc bloc = context.read<CharacterListBloc>();
        bloc.add(
          LoadCharactersWithFilter(
            page: bloc.currentPage,
            status: bloc.selectedStatus,
            species: bloc.selectedSpecies,
          ),
        );
      }
    }
  });
}
