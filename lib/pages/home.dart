import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const String route = '/';

  @override 
  Widget build(BuildContext ctx){
    return Scaffold(
      appBar: AppBar(title: Text("Ideas"),),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}