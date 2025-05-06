import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:flutter/material.dart';
import '../bloc/character_list_bloc.dart';

class SpeciesDropdown extends StatelessWidget {
  const SpeciesDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CharacterListBloc, CharacterListState>(
      builder: (BuildContext context, CharacterListState state) {
        final CharacterListBloc bloc = context.read<CharacterListBloc>();

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
    );
  }
}
