import 'package:Minesweeper/View/aboutPage.dart';
import 'package:Minesweeper/View/gamePage.dart';
import 'package:Minesweeper/View/leaderboardPage.dart';
import 'package:Minesweeper/View/settingsPage.dart';
import 'package:Minesweeper/View/userSetupPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:Minesweeper/Model/enums.dart';
import 'package:Minesweeper/Model/table.dart';

void main() {
  runApp(MenuPage());
}

class MenuPage extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '🚩 Minesweeper 💣',
      theme: ThemeData(
          primarySwatch: Colors.grey,
          primaryColor: Colors.grey[900],
          primaryTextTheme:
              TextTheme(headline6: TextStyle(color: Colors.white))),
      home: MyHomePage(title: ". : [ M I N E S W E E P E R ] : ."),
      color: Colors.grey[800],
    );
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  GestureDetector(
                    child: SimpleButton("NEW GAME", Colors.grey[800],
                        Colors.white, Icons.outlined_flag),
                    onTap: () => navigateToGamePage(context),
                  ),
                  GestureDetector(
                    child: SimpleButton("LEADERBOARD", Colors.grey[800],
                        Colors.white, Icons.poll),
                    onTap: () => navigateToLeaderboardPage(context),
                  ),
                  GestureDetector(
                    child: SimpleButton("SETTINGS", Colors.grey[800],
                        Colors.white, Icons.settings),
                    onTap: () => navigateToSettingsPage(context),
                  ),
                  GestureDetector(
                    child: SimpleButton("ABOUT", Colors.grey[800], Colors.white,
                        Icons.info_outline),
                    onTap: () => navigateToAboutPage(context),
                  ),
                ]))));
  }

  Widget SimpleButton(
      String text, Color borderColor, Color bgColor, IconData icon) {
    return Padding(
        padding: EdgeInsets.all(20),
        child: Container(
            height: 40,
            width: MediaQuery.of(context).size.width / 2,
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
                Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(text,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center)),
              ],
            )));
  }
  
  Future navigateToSettingsPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SettingsPage()));
  }

Future navigateToAboutPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => AboutPage()));
  }

Future navigateToLeaderboardPage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LeaderboardPage()));
  }

  Future navigateToGamePage(context) async {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => UserSetupPage()));
  }
}
