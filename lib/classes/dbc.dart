import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'idea.dart';

class DataBaseHelper {
  static Future<Database> get database async {
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

  Future<void> insertIdea(Idea idea) async{
    final Database db = await database;

    await db.insert(
      'ideas',
      idea.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List <Idea>> ideas() async{
    final Database db = await database;

    final List<Map<String, dynamic>> maps = await db.query('ideas');

    return List.generate(maps.length, (i){
      return Idea(
        id: maps[i]['id'],
        name: maps[i]['name'],
        description: maps[i]['description'],
      );
    });
  }

  Future<void> updateIdea(Idea idea) async {
    final Database db = await database;

    await db.update('ideas', 
      idea.toMap(),
      where: "id = ?",
      whereArgs: [idea.id],
    );
  }

  Future<void> deleteIdea(int id) async{
    final Database db = await database;

    await db.delete(
      'dogs',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}