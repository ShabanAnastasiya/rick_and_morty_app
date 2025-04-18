import 'package:core_ui/src/widgets/detail_field.dart';
import 'package:data/src/entities/character.dart';
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(character.image),
              ),
              const SizedBox(height: 16),
              Text(
                'Name: ${character.name}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              DetailField(
                label: 'Status',
                value: character.status,
              ),
              DetailField(
                label: 'Species',
                value: character.species,
              ),
              DetailField(
                label: 'Created',
                value: character.created.toString(),
              ),
              DetailField(
                label: 'Gender',
                value: character.gender,
              ),
              DetailField(
                label: 'Location',
                value: character.location.name,
              ),
              DetailField(
                label: 'Origin',
                value: character.origin.name,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
