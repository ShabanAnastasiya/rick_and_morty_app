import 'package:dio/dio.dart';
import '../entities/character.dart';

class CharacterProvider {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://rickandmortyapi.com/api/',
    ),
  );

  Future<Map<String, dynamic>> getCharacterList(
    int page,
    String? status,
    String? species,
  ) async {
    try {
      final Map<String, String> queryParams = <String, String>{
        'page': page.toString(),
        if (status != null) 'status': status.toLowerCase(),
        if (species != null) 'species': species.toLowerCase(),
      };

      final response = await _dio.get(
        'character',
        queryParameters: queryParams,
      );

      final data = response.data;
      final results = data['results'] as List;
      final int totalPages = data['info']['pages'];

      return {
        'characters':
            results.map((json) => Result.fromJson(json)).toList(),
        'totalPages': totalPages,
      };
    } on DioException catch (e) {
      throw Exception(e);
    }
  }
}
