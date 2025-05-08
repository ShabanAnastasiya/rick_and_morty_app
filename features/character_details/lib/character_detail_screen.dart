import 'package:core/core.dart';
import 'package:core_ui/core_ui.dart';
import 'package:core_ui/src/widgets/detail_field.dart';
import 'package:data/data.dart';
import 'package:flutter/material.dart';
import 'package:navigation/navigation.dart';

@RoutePage()
class CharacterDetailScreen extends StatelessWidget {
  final Result character;

  const CharacterDetailScreen({
    super.key,
    required this.character,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.PADDING_16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(character.image),
              ),
              const SizedBox(height: 16),
              Text(
                '${AppConstants.NAME_LABEL}: ${character.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DetailField(
                label: AppConstants.STATUS_LABEL,
                value: character.status,
              ),
              DetailField(
                label: AppConstants.SPECIES_LABEL,
                value: character.species,
              ),
              DetailField(
                label: AppConstants.CREATED_LABEL,
                value: character.created.toString(),
              ),
              DetailField(
                label: AppConstants.GENDER_LABEL,
                value: character.gender,
              ),
              DetailField(
                label: AppConstants.LOCATION_LABEL,
                value: character.location.name,
              ),
              DetailField(
                label: AppConstants.ORIGIN_LABEL,
                value: character.origin.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
