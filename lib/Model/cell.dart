import 'dart:math';

import 'enums.dart';

class Cell {
  int posX = -1;
  int posY = -1;
  int number = -1;
  bool isBomb = false;
  bool isMarked = false;
  bool isRevealed = false;

  CellType getCellType() {
    if (isRevealed) {
      if (isBomb) {
        return CellType.Bomb;
      } else {
        return CellType.Explored;
      }
    } else {
      if (isMarked) {
        return CellType.Marked;
      } else {
        return CellType.UnExplored;
      }
    }
  }

  double getDistance(int x, int y) {
    return sqrt((x - posX) * (x - posX) + (y - posY) * (y - posY));
  }

  bool IsNeighbour(int x, int y) {
    return getDistance(x, y) < 2;
  }


  IsNumberNeighbour(int x, int y) {
    return IsNeighbour(x, y) && !isBomb && !isMarked && !isRevealed ;
  }

bool IsEmptyNeighbour(int x, int y) {
    return IsNeighbour(x, y) && !isBomb && !isMarked && !isRevealed && number ==0;
  }

  bool IsBombNeighbour(int x, int y) {
    return IsNeighbour(x, y) && isBomb;
  }
}
