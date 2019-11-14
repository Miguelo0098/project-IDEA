import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'idea.dart';
import 'dart:async';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String ideaTable = 'idea_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }


  Future<Database> get database async{
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'ideas.db';

    var ideasDatabase = await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );

    return ideasDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $ideaTable($colId INTEGER PRIMARY KEY, $colTitle TEXT, $colDescription TEXT)');

  }

  Future<List<Map<String, dynamic>>> getIdeaMapList() async{
    Database db = await this.database;
    
    var result = await db.query(ideaTable, orderBy: '$colTitle ASC');
    return result;
  }

  Future<int> insertIdea(Idea idea) async{
    Database db = await this.database;

    var result = await db.insert(ideaTable, idea.toMap());
    return result;
  }

  Future<int> updateIdea(Idea idea) async{
    var db = await this.database;
    var result = await db.update(
      ideaTable, 
      idea.toMap(), 
      where: '$colId = ?',
      whereArgs: [idea.id]
    );
    return result;
  }

  Future<int> deleteIdea(int id) async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $ideaTable WHERE $colId = $id');
    return result;
  }

  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $ideaTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Idea>> getIdeaList() async{
    var ideaMapList = await getIdeaMapList();
    int count = ideaMapList.length;

    List<Idea> ideaList = List<Idea>();
    for (int i = 0; i < count; i++) {
      ideaList.add(Idea.fromMapObject(ideaMapList[i]));
    }

    return ideaList;
  }

}