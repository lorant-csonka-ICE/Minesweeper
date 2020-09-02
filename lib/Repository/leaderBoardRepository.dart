import 'dart:convert';

import 'package:Minesweeper/Model/player.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderBoardRepository {

  static Future<List<Player>> getLocalLeaderBoard() async {
    var prefs = await SharedPreferences.getInstance();
    var key = 'leaderBoard';
    var value = prefs.getString(key) ?? "";

    if (value != "") {
      Iterable l = json.decode(value);
      List<Player> playerList = List<Player>.from(l.map((i) => Player.fromJson(i)));
      return playerList;
    } else
      return new List<Player>();
  }

  static setlocalLeaderBoard(List<Player> playerList) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'leaderBoard';
    final value =jsonEncode(playerList).toString();
    prefs.setString(key, value);
  }
}
