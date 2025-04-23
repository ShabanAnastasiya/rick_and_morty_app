import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'bloc/character_list_bloc.dart';
import 'custom_dropdown_button.dart';

class StatusDropdown extends StatelessWidget {
  const StatusDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<CharacterListBloc, CharacterListState>(
      builder: (BuildContext context, CharacterListState state) {
        final CharacterListBloc bloc = context.read<CharacterListBloc>();

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
    );
  }
}
