import 'package:Minesweeper/Controller/gameController.dart';
import 'package:Minesweeper/Model/player.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Minesweeper/Model/enums.dart';
import 'package:Minesweeper/Model/table.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LeaderboardPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MyHomePage(title: ". : [ L E A D E R B O A R D ] : .");
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   leaderBoard = GameController.getLeaderBoard();

  }

  void _retry() {
    setState(() {
      leaderBoard = GameController.getLeaderBoard();
    });
  }

  Future<List<Player>> leaderBoard;

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
            child: Center( child:
        FutureBuilder<List<Player>>(
          future: leaderBoard,
          builder: (BuildContext context, AsyncSnapshot<List<Player>> snapshot) {
            if (snapshot.hasData) {
              var userList = snapshot?.data?.toList();
              userList.sort((a,b) => a.points.compareTo(b.points));

                  return  new ListView.builder
      (
        itemCount: snapshot.data.length,
        itemBuilder: (BuildContext ctxt, int index) {
            var duration =  new Duration(
      days: 0, hours: 0, minutes: 0, seconds: 0, milliseconds: int.tryParse(userList[index]?.time));

                  return SimpleButton(index+1,userList[index]?.name , duration?.toString().substring(0,11) ?? "00:00:00.000" , Colors.grey[800], Colors.white,  FontAwesomeIcons.hashtag);
                 //  return SimpleButton("[ "+(index+1).toString()+" ]  "+(userList[index]?.name ?? "" ) +"  -  " +(duration?.toString().substring(0,11) ?? "00:00:00.000" +"."), Colors.grey[800], Colors.white,  FontAwesomeIcons.hashtag);

        }
    );


              //  return Column(
              //       crossAxisAlignment: CrossAxisAlignment.center,
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: <Widget>[
              //        userList.length>0? SimpleButton("["+(userList[0]?.name ?? "")+"] : "+(userList[0]?.time ?? ""), Colors.grey[800], Colors.white, Icons.looks_one),
              //        SimpleButton("["+(userList[2]?.name ?? "")+"] : "+(userList[2]?.time ?? ""), Colors.grey[800], Colors.white, Icons.looks_3),
              //        SimpleButton("["+(userList[3]?.name ?? "")+"] : "+(userList[3]?.time ?? ""), Colors.grey[800], Colors.white, Icons.looks_4),
              //        SimpleButton("["+(userList[4]?.name ?? "")+"] : "+(userList[4]?.time ?? ""), Colors.grey[800], Colors.white, Icons.looks_5),
              //        SimpleButton("["+(userList[5]?.name ?? "")+"] : "+(userList[5]?.time ?? ""), Colors.grey[800], Colors.white, Icons.looks_6),
              //   ]);
            }}))))                ;
  }

  Widget SimpleButton(
      int index, String name, String time, Color borderColor, Color bgColor, IconData icon) {
    return Padding(
        padding: EdgeInsets.only(left:20,right:20, top:10, bottom:10),
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width - 20,
            padding: EdgeInsets.only(left: 6, right: 6, bottom: 2),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(
                  color: borderColor,
                  width: 3.0,
                )), //       <--- BoxDecoration here
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon),
                Expanded(
                    flex: 2,
                    child: Text("[ "+(index).toString()+" ]",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
                         Expanded(
                    flex: 5,
                    child: Text(name ?? "",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start)),
                         Expanded(
                    flex: 5,
                    child: Text(time ?? "0:00:00.000",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],




           //  "(userList[index]?.name ?? "" ) +"  -  " +(duration?.toString().substring(0,11) ?? "00:00:00.000" +"."),


            )));
  }

}
