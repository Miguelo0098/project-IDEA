import 'dart:async';
import 'package:flutter/material.dart';

import 'package:project_idea/classes/idea.dart';
import 'package:project_idea/classes/dbc.dart';
import 'package:intl/intl.dart';

class IdeaDetail extends StatefulWidget {
  final String appBarTitle;
  final Idea idea;

  IdeaDetail(this.idea, this.appBarTitle);

  @override 
  State<StatefulWidget> createState(){
    return IdeaDetailState(this.idea, this.appBarTitle);
  }
}

class IdeaDetailState extends State<IdeaDetail>{
  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Idea idea;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  IdeaDetailState(this.idea, this.appBarTitle);

  @override 
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = idea.title;
    descriptionController.text = idea.description;

    return WillPopScope(
      onWillPop: (){
        moveToLastScreen();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(appBarTitle),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back
            ),
            onPressed: (){
              moveToLastScreen();
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
          child: ListView(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextField(
                  controller: titleController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5)
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: TextField(
                  controller: descriptionController,
                  style: textStyle,
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                    labelText: 'Description',
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(2.5)
                    )
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: (){
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),

                    Container(width: 5.0,),

                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: (){
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    )
                  ],
                ),
              )
            ],
          )
        ),
      ),
    );
  }

  void moveToLastScreen(){
    Navigator.pop(context, true);
  }

  void updateTitle(){
    idea.title = titleController.text;
  }

  void updateDescription(){
    idea.description = descriptionController.text;
  }

  void _save() async{
    moveToLastScreen();

    int result;
    if (idea.id != null) {
      result = await helper.updateIdea(idea);
      
    } else{
      result = await helper.insertIdea(idea);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Idea Saved Successfully');
    }else{
      _showAlertDialog('Status', 'Error Saving Idea');
    }
  }

  void _delete() async{
    moveToLastScreen();

    if (idea.id == null) {
      _showAlertDialog('Status', 'No Idea was deleted');
      return;
    }
      
    
    int result = await helper.deleteIdea(idea.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Idea Deleted Successfully');
    }else{
      _showAlertDialog('Status', 'Error Ocurred while Deleting Idea');
    }
  }

  void _showAlertDialog(String title, String message){
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
      context: context,
      builder: (_) => alertDialog
    );
  }
}