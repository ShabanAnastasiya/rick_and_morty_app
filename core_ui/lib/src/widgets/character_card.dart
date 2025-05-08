import 'package:core/core.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';

import '../../core_ui.dart';

class CharacterCard extends StatelessWidget {
  final Result character;
  final bool isFav;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onTap;

  const CharacterCard({
    super.key,
    required this.character,
    required this.isFav,
    required this.onFavoriteToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(AppDimens.PADDING_12),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.PADDING_12),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            character.name,
                            style: const TextStyle(fontSize: 17),
                          ),
                          ColorCircleRow(
                            text: '${character.status} -- ${character.species}',
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
                onPressed: onFavoriteToggle,
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
  }
}
