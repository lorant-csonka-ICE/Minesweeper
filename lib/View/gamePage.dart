import 'dart:typed_data';

import 'package:Minesweeper/Controller/gameController.dart';
import 'package:Minesweeper/Model/player.dart';
import 'package:Minesweeper/Repository/leaderBoardRepository.dart';
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

class GamePage extends StatelessWidget {
  String userName = "";
  GamePage(String this.userName){

  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: '🚩 Minesweeper 💣',
    //   theme: ThemeData(
    //       primarySwatch: Colors.grey,
    //       primaryColor: Colors.grey[900],
    //       primaryTextTheme:
    //           TextTheme(headline6: TextStyle(color: Colors.white))),
    //   home:
    return MyHomePage(title: ". : [ N E W  G A M E ] : .   ", userName: userName,);
    //   color: Colors.grey[800],
    // );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.userName}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
   String userName= "";

  @override
  _MyHomePageState createState() => _MyHomePageState(userName);
}

class _MyHomePageState extends State<MyHomePage> {
  
   String userName= "";

  _MyHomePageState(this.userName){
  }

  ConfettiController _controllerBottomCenter;
  static String displayTime = "00:00:00";

  int _counter = 0;
  int tableSize = 4;
  Difficulty difficulty = Difficulty.Easy;
  GameTable gameTable;

  // Diplayed variables
  int bombCount = 0;
  int reveiledCount = 0;
  int flaggedCount = 0;
  bool isGameOver = false;
  bool isGameStarted = false;
  Soundpool _soundpool;
  AssetBundle rootBoundle;
  DateTime gameStartTime;
  DateTime gameEndTime;

  int gongSoundId = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));
    _soundpool = Soundpool();
    rootBoundle = DefaultAssetBundle.of(context);

    resetTable();
  }

  Future<void> playWinSound() async {
    int soundId =
        await rootBundle.load("assets/win.mp3").then((ByteData soundData) {
      return _soundpool.load(soundData);
    });

    await _soundpool.play(soundId);
  }

  Future<void> playLoseSound() async {
    int soundId = await rootBundle
        .load("assets/game_over.mp3")
        .then((ByteData soundData) {
      return _soundpool.load(soundData);
    });

    await _soundpool.play(soundId);
  }

  Future<void> playGongSound() async {
    int soundId =
        await rootBundle.load("assets/gong.mp3").then((ByteData soundData) {
      return _soundpool.load(soundData);
    });

    await _soundpool.play(soundId);
  }

  @override
  void dispose() async {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  void resetTable() {
    gameTable = new GameTable(tableSize, difficulty);
    isGameOver = false;
    isGameStarted = false;
    updateCounters();

  }

  double baseWidth;

  @override
  Widget build(BuildContext context) {
    baseWidth = MediaQuery.of(context).size.width - 20;
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
              Container(
                  width: baseWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SimpleButton(bombCount.toString(), Colors.grey[800],
                          Colors.white, FontAwesomeIcons.bomb),
                      SimpleButton(
                          reveiledCount.toString() +
                              "/" +
                              (tableSize * tableSize).toString(),
                          Colors.grey[800],
                          Colors.white,
                          FontAwesomeIcons.checkCircle),
                      SimpleButton(flaggedCount.toString(), Colors.grey[800],
                          Colors.white, FontAwesomeIcons.flag),
                    ],
                  )),
              Container(
                width: baseWidth,
                height: baseWidth,
                child: GridView.builder(
                  primary: false,
                  itemCount: tableSize * tableSize,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: tableSize),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                        child: getCell(index),
                        onLongPress: () {
                          if (!isGameOver) {
                            setState(() {
                              var cell = gameTable.cellTable[index];
                              if (cell.isMarked) {
                                cell.isMarked = false;
                              } else {
                                cell.isMarked = true;
                              }

                              updateCounters();
                              if (!isGameStarted) {
                                gameStartTime = DateTime.now();
                                isGameStarted = true;
                                playGongSound();
                              }
                            });
                          }
                        },
                        onTap: () {
                          if (!isGameOver) {
                            setState(() {
                              var cell = gameTable.cellTable[index];
                              if (!cell.isRevealed && cell.isMarked) {
                                cell.isMarked = false;
                              } else {
                                cell.isRevealed = true;
                                if (!cell.isBomb && cell.number == 0) {
                                  gameTable.revealEmptyNeighbours(cell);
                                }
                              }
                              updateCounters();
                              if (!isGameStarted) {
                                gameStartTime = DateTime.now();
                                isGameStarted = true;
                                playGongSound();
                              }
                            });
                          }
                        });
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: ConfettiWidget(
                  confettiController: _controllerBottomCenter,
                  blastDirection: -3.1415 / 2,
                  emissionFrequency: 0.01,
                  numberOfParticles: 20,
                  maxBlastForce: 100,
                  minBlastForce: 80,
                  gravity: 0.3,
                ),
              ),
              Container(
                  width: baseWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SimpleButton(displayTime, Colors.grey[800], Colors.white,
                      //     FontAwesomeIcons.clock),
                      GestureDetector(
                        onTap: () {
                          //  <---  CONFETTI
                          setState(() {
                            resetTable();
                          });
                        },
                        child: SimpleButton("", Colors.grey[800], Colors.white,
                            FontAwesomeIcons.redo),
                      ),

                      // Container(
                      //   margin: const EdgeInsets.all(5.0),
                      //   padding: const EdgeInsets.all(5.0),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border.all(
                      //         color: Colors.blue[
                      //             800], //                   <--- border color
                      //         width: 3.0,
                      //       )), //       <--- BoxDecoration here
                      //   child: Text(
                      //     "--:--:--",
                      //     style: TextStyle(
                      //         fontSize: 18.0,
                      //         color: Colors.blue[900],
                      //         fontWeight: FontWeight.bold),
                      //   ),
                      // ),
                      // GestureDetector(
                      //     onTap: () {
                      //       setState(() {
                      //         resetTable();
                      //       });
                      //     },
                      //     child: Container(
                      //       margin: const EdgeInsets.all(5.0),
                      //       padding: const EdgeInsets.all(5.0),
                      //       decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           border: Border.all(
                      //             color: Colors.deepOrange[
                      //                 400], //                   <--- border color
                      //             width: 3.0,
                      //           )), //       <--- BoxDecoration here
                      //       child: Text(
                      //         "RESET",
                      //         style: TextStyle(
                      //             fontSize: 18.0,
                      //             color: Colors.deepOrange[800],
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ))
                    ],
                  )),
              gameOverPopup()
            ],
          )),
        ));
  }

  bool hasWon = false;

  Widget gameOverPopup() {

   
    // By default the overlay (since this is a Column) will
    // be added right below the raised button
    // but outside the widget tree.
    // We can change that by supplying a "position".
    return OverlayContainer(
      show: isGameOver,
      // Let's position this overlay to the right of the button.
      position: OverlayContainerPosition(
        // Left position.
        (MediaQuery.of(context).size.width / 2) - 135,
        // Bottom position.
        (MediaQuery.of(context).size.height / 2),
      ),
      // The content inside the overlay.
      child: GestureDetector(
          onTap: () {
            setState(() {
              resetTable();
               _controllerBottomCenter.stop();
            });
          },
          child: Container(
            height: hasWon? 200:100,
            width: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: hasWon ? Colors.green : Colors.red,
                  blurRadius: 2,
                  spreadRadius: 6,
                )
              ],
            ),
            child: hasWon
                ? 
                  SimpleButton("CONGRATS, YOU WON!\n\nYOUR TIME IS:\n["+(gameEndTime.difference(gameStartTime)).toString().substring(0,11)+"]\n\n(press here to restart)",
                    Colors.grey[800], Colors.white, FontAwesomeIcons.trophy)
                    
                :
                SimpleButton(
                    "YOU EXPLODED!\n\n(press here to restart)",
                    Colors.grey[800],
                    Colors.white,
                    FontAwesomeIcons.skullCrossbones)
                
            // child: Text(
            //   "YOU EXPLODED!",
            //   style:
            //       TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          )),
    );
  }

  void updateCounters() {
    bombCount = gameTable.count(CellType.Bomb);
    reveiledCount = gameTable.count(CellType.Explored);
    flaggedCount = gameTable.count(CellType.Marked);

    var exploded = gameTable.count(CellType.Exploded);

    if (exploded > 0) {
      gameEndTime = DateTime.now();

      playLoseSound();
      print("LOOSE");
      hasWon = false;

      isGameOver = true;
      ;
    }

    var unrevieled = gameTable.count(CellType.UnExplored);

    if (unrevieled == 0) {
      setState(() {
        gameEndTime = DateTime.now();
        playWinSound();
        _controllerBottomCenter.play();
        print("WIN");
        hasWon = true;
         if(hasWon && userName.isNotEmpty && userName!="ANONYMUS"){
      var user = new Player();
      user.name=userName;
      user.time = gameEndTime.difference(gameStartTime).inMilliseconds.toString();
      user.points = gameEndTime.difference(gameStartTime).inMilliseconds;
      GameController.addPlayerToLeaderBoard( user);
    }
        isGameOver = true;
        // WIN!
      });
    }
  }

  Widget getCell(int index) {
    var aa = gameTable.cellTable[index];
    if (aa != null) {
      var cellType = aa.getCellType();
      switch (cellType) {
        case CellType.Marked:
          return markedCell();
          break;
        case CellType.Bomb:
          return bombCell();
          break;
        case CellType.Exploded:
          return bombCell();
          break;
        case CellType.UnExplored:
          return unknownCell();
          break;
        case CellType.Explored:
          return revieldCell(aa.number);
          break;
        default:
          return unknownCell();
      }
    }
  }

  Widget unknownCell() {
    return new Container(
        color: Colors.grey[800],
        margin: EdgeInsets.all(1),
        child: Stack(children: [
          new Container(color: Colors.grey[500], margin: EdgeInsets.all(3)),
        ]));
  }

  Widget revieldCell(int bombIndex) {
    Color bgColor = Colors.grey[50];
    switch (bombIndex) {
      case 0:
        bgColor = Colors.grey[50];
        break;
      case 1:
        bgColor = Colors.orange[50];
        break;
      case 2:
        bgColor = Colors.orange[100];
        break;
      case 3:
        bgColor = Colors.orange[200];
        break;
      case 4:
        bgColor = Colors.orange[300];
        break;
      case 5:
        bgColor = Colors.orange[400];
        break;
      case 6:
        bgColor = Colors.red[200];
        break;
      case 7:
        bgColor = Colors.red[300];
        break;
      case 8:
        bgColor = Colors.red[400];
        break;
    }

    return new Container(
        color: Colors.grey[800],
        margin: EdgeInsets.all(1),
        child: Stack(children: [
          new Container(color: bgColor, margin: EdgeInsets.all(3)),
          Align(
              alignment: Alignment.center,
              child: bombIndex > 0
                  ? Text(
                      bombIndex.toString(),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  : Text("")),
        ]));
  }

  Widget markedCell() {
    return new Container(
        color: Colors.green[900],
        margin: EdgeInsets.all(1),
        child: Stack(children: [
          new Container(color: Colors.green[500], margin: EdgeInsets.all(3)),
          Align(
            alignment: Alignment.center,
            child: Text(
              "🚩",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ]));
  }

  Widget bombCell() {
    return new Container(
        color: Colors.black87,
        margin: EdgeInsets.all(1),
        child: Stack(children: [
          new Container(color: Colors.red[500], margin: EdgeInsets.all(3)),
          Align(
            alignment: Alignment.center,
            child: Text(
              "💣",
              style: TextStyle(fontSize: 20),
            ),
          ),
        ]));
  }

  Widget SimpleButton(
      String text, Color borderColor, Color bgColor, IconData icon) {
    return Padding(
        padding: EdgeInsets.all(5),
        child: Container(
            height: 40,
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
                FaIcon(icon),
                text.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(text,
                            style: TextStyle(
                                fontSize: 15.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center))
                    : Padding(padding: EdgeInsets.all(1))
              ],
            )));
  }
}

class Count {}
