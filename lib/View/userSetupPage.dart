import 'package:Minesweeper/View/gamePage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Minesweeper/Model/enums.dart';
import 'package:Minesweeper/Model/table.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import 'dart:typed_data';

import 'package:Minesweeper/Controller/gameController.dart';
import 'package:Minesweeper/View/menuPage.dart';
import 'package:Minesweeper/Widgets/confetti.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Minesweeper/Model/enums.dart';
import 'package:Minesweeper/Model/table.dart';
import 'package:flutter/src/services/asset_bundle.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:overlay_container/overlay_container.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:soundpool/soundpool.dart';


class UserSetupPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MyHomePage(title: ". : [ N E W  G A M E ] : .");
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _controller;

  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      
                     TextInputArea("[ L E V E L ] : e a s y ", Colors.grey[800], Colors.white, FontAwesomeIcons.trophy),
                     GestureDetector(
                    child: SimpleButton("[ S T A R T ]", Colors.grey[800], Colors.white,  FontAwesomeIcons.flagCheckered),
                    onTap: () => navigateToGamePage(context),
                  ),
                     
                ]))));
  }

  Widget SimpleButton(
      String text, Color borderColor, Color bgColor, IconData icon) {
    return Padding(
        padding: EdgeInsets.only(left:20,right:20, top:10, bottom:10),
        child: Container(
            height: 70,
            width: 200,
            padding: EdgeInsets.only(left: 6, right: 6, bottom: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: borderColor,
                  width: 3.0,
                )), //       <--- BoxDecoration here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon),
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        style: TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],
            )));
  }


Widget TextInputArea(
      String text, Color borderColor, Color bgColor, IconData icon) {
    return Padding(
        padding: EdgeInsets.only(left:20,right:20, top:10, bottom:10),
         child://       <--- BoxDecoration here
            TextField(
              controller: _controller,
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: borderColor, width: 3.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 3.0),
                ),
                hintText: 'PLAYER NAME',
                hintStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                counterStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                suffixStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                labelStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                errorStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                helperStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                prefixStyle: TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
              ), 

            ));}
              

            Future navigateToGamePage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => GamePage(_controller.text ?? "ANONYMUS")));
  }  


}



