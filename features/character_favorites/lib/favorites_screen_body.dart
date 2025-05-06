import 'package:core/core.dart';
import 'package:data/src/entities/character.dart';
import 'package:flutter/material.dart';
import 'bloc/favorites_bloc.dart';

class FavoritesScreenBody extends StatelessWidget {
  const FavoritesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesBloc, FavoritesState>(
      builder: (BuildContext context, FavoritesState state) {
        if (state is FavoritesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FavoritesLoaded) {
          final List<Result> favs = state.characters;

          return favs.isEmpty
              ? const Center(child: Text(AppConstants.EMPTY_FAVORITES_LIST))
              : ListView.builder(
            itemCount: favs.length,
            itemBuilder: (_, int index) {
              final Result c = favs[index];

              return Row(
                children: <Widget>[
                  Flexible(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        c.image,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text(c.name),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<FavoritesBloc>().add(
                            ToggleFavorites(c),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is FavoritesError) {
          return const Center(child: Text(AppConstants.SELECT_PAGE));
        }
        return const Center(child: Text(AppConstants.SELECT_PAGE));
      },
    );
  }
}
