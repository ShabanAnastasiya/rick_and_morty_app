import 'dart:convert';
import 'package:http/http.dart' as http;

import '../entities/character.dart';

class CharacterProvider {
  final String baseUrl = 'https://rickandmortyapi.com/api/';

  Future<Map<String, dynamic>> getCharacterList(
    int page,
    String? status,
    String? species,
  ) async {
    final Map<String, String> queryParams = <String, String>{
      'page': page.toString(),
      if (status != null) 'status': status.toLowerCase(),
      if (species != null) 'species': species.toLowerCase(),
    };

    final uri = Uri.parse('${baseUrl}character').replace(queryParameters: queryParams);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final results = data['results'] as List;
      final totalPages = data['info']['pages'];

      return {
        'characters': results.map((json) => Result.fromJson(json)).toList(),
        'totalPages': totalPages,
      };
    } else {
      throw Exception('Failed to load characters');
    }
  }
}
