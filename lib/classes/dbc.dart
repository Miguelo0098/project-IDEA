import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  Future<Database> get database async {
    return openDatabase(
      join(await getDatabasesPath(), 'ideas_database.db'),

      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE ideas(id INTEGER PRIMARY KEY, name TEXT, description TEXT)"
        );
      },

      version: 1,
    );
  }
}