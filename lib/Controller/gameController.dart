import 'package:Minesweeper/Model/player.dart';
import 'package:Minesweeper/Repository/LeaderBoardRepository.dart';

class GameController {
  static List<Player> leaderBoard = new List<Player>();
   GameController() {
    leaderBoard = new List<Player>();
  }
  
 static Future<void> refreshRuntimeLeaderBoardFromLocal() async {
    leaderBoard = await LeaderBoardRepository.getLocalLeaderBoard();
  }

  static Future<void> addPlayerToLeaderBoard(Player player) async {
    await refreshRuntimeLeaderBoardFromLocal();
    leaderBoard.add(player);
    LeaderBoardRepository.setlocalLeaderBoard(leaderBoard);
  }

  static Future<List<Player>> getLeaderBoard() async {
    await refreshRuntimeLeaderBoardFromLocal();
    return leaderBoard;
  }

  static Future cleanLeaderBoard() async {
    leaderBoard = new List<Player>();
    await LeaderBoardRepository.setlocalLeaderBoard(leaderBoard);
  }
}
