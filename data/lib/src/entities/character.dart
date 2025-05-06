import 'package:hive/hive.dart';

part 'character.g.dart';

class Character {
  final Info info;
  final List<Result> results;

  Character({required this.info, required this.results});

  factory Character.fromJson(Map<String, dynamic> json) {
    return Character(
      info: Info.fromJson(json['info']),
      results: List<Result>.from(
        json['results'].map((dynamic x) => Result.fromJson(x)),
      ),
    );
  }
}

class Info {
  final int count;
  final int pages;
  final String next;
  final String prev;

  Info({
    required this.count,
    required this.pages,
    required this.next,
    required this.prev,
  });

  factory Info.fromJson(Map<String, dynamic> json) {
    return Info(
      count: json['count'],
      pages: json['pages'],
      next: json['next'],
      prev: json['prev'],
    );
  }
}

@HiveType(typeId: 0)
class Result {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final Location origin;

  @HiveField(7)
  final Location location;

  @HiveField(8)
  final String image;

  @HiveField(9)
  final List<String> episode;

  @HiveField(10)
  final String url;

  @HiveField(11)
  final DateTime created;

  Result({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.image,
    required this.episode,
    required this.url,
    required this.created,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      id: json['id'],
      name: json['name'],
      status: json['status'],
      species: json['species'],
      type: json['type'],
      gender: json['gender'],
      origin: Location.fromJson(json['origin']),
      location: Location.fromJson(json['location']),
      image: json['image'],
      episode: List<String>.from(json['episode'].map((dynamic x) => x)),
      url: json['url'],
      created: DateTime.parse(json['created']),
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'status': status,
        'species': species,
        'type': type,
        'gender': gender,
        'origin': origin.toJson(),
        'location': location.toJson(),
        'image': image,
        'episode': List<String>.from(episode),
        'url': url,
        'created': created.toIso8601String(),
      };
}

@HiveType(typeId: 1)
class Location {
  @HiveField(0)
  String name;

  @HiveField(1)
  String url;

  Location({required this.name, required this.url});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(name: json['name'], url: json['url']);

  Map<String, dynamic> toJson() => <String, dynamic>{'name': name, 'url': url};
}
