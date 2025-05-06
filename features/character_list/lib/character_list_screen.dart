import 'package:auto_route/auto_route.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';
import 'bloc/character_list_bloc.dart';
import 'character_list_screen_body.dart';

@RoutePage()
class CharacterListScreen extends StatelessWidget {
  const CharacterListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider<CharacterListBloc>(
        create: (_) => appLocator<CharacterListBloc>()
          ..add(LoadCharactersWithFilter(page: 1)),
        child: const CharacterListScreenBody(),
      ),
    );
  }
}
