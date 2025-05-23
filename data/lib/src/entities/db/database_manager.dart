import 'dart:io';

import 'package:core/src/logger/logger.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data.dart';

class DatabaseManager {
  late Box<List<Result>> _charactersBox;
  late Box<Result> _favoritesBox;

  Box<List<Result>> get charactersBox => _charactersBox;

  Box<Result> get favoritesBox => _favoritesBox;

  Future<void> init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);

    Hive.registerAdapter(ResultAdapter());
    Hive.registerAdapter(LocationAdapter());

    _charactersBox = await Hive.openBox<List<Result>>('characters');

    final AppLogger appLogger = AppLogger();
    appLogger.debug('Box opened, contains: ${_charactersBox.length} items');

    _favoritesBox = await Hive.openBox<Result>('favoritesBox');
  }
}
