import 'package:flutter/material.dart';
import 'package:project_idea/classes/idea.dart';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:project_idea/classes/dbc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String route = '/';
  final DataBaseHelper dataBaseHelper = new DataBaseHelper();  

  @override 
  Widget build(BuildContext ctx) {

    return Scaffold(
      appBar: AppBar(title: Text("Ideas"),),
      body: ListView.builder(
        itemCount: ,
      )
    );
  }
}