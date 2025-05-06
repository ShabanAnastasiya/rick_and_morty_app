import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/character_list_bloc.dart';

void setupCharacterScrollListener({
  required ScrollController controller,
  required BuildContext context,
}) {
  controller.addListener(() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      context.read<CharacterListBloc>().add(LoadMoreCharacters());
    }
  });
}
