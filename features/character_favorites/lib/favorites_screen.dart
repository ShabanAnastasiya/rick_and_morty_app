import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

import 'bloc/favorites_bloc.dart';
import 'favorites_screen_body.dart';

@RoutePage()
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create:
            (_) =>
                appLocator<FavoritesBloc>()
                  ..add(LoadFavorites()),
        child: FavoritesScreenBody(),
      ),
    );
  }
}
