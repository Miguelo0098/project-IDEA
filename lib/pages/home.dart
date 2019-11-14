import 'package:flutter/material.dart';
import 'package:project_idea/classes/idea.dart';

import 'package:project_idea/classes/dbc.dart';
import 'package:sqflite/sqflite.dart';

import 'details.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const String route = '/';
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Idea> ideaList;
  int count = 0;

  @override 
  Widget build(BuildContext ctx) {
    if (ideaList == null) {
      ideaList = List<Idea>();
      updateListView();
    }

    return Scaffold(
      appBar: AppBar(title: Text("Ideas"),),
      body: getIdeaListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          debugPrint('FAB clicked');
          navigateToDetail(Idea('', ''), 'Add Todo');
        },
        tooltip: 'Add Idea',
        child: Icon(Icons.add),
      ),
      
    );
  }

  ListView getIdeaListView(){
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position){
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.ideaList[position].title),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(this.ideaList[position].title,
              style: TextStyle(fontWeight: FontWeight.bold),

            ),

            subtitle: Text(this.ideaList[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red),
                  onTap: (){
                    _delete(context, ideaList[position]);
                  },
                )
              ],
            ),
            onTap: (){
              debugPrint('ListTile Tapped');
              navigateToDetail(this.ideaList[position], 'Edit Idea');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title){
    return title.substring(0,2);
  }

  void _delete(BuildContext context, Idea idea) async{
    int result = await databaseHelper.deleteIdea(idea.id);
    if (result != 0){
      _showSnackBar(context, 'Idea Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message){
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Idea idea, String title) async{
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return IdeaDetail(idea, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){
      Future<List<Idea>> ideaListFuture = databaseHelper.getIdeaList();
      ideaListFuture.then((ideaList){
        setState(() {
          this.ideaList = ideaList;
          this.count = ideaList.length;
        });
      });
    });
  }
}