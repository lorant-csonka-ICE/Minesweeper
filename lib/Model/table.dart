import 'dart:math';

import 'package:Minesweeper/Model/enums.dart';

import 'cell.dart';

class GameTable {
  List<Cell> cellTable;
  static int size;
  GameTable(int tableSize, Difficulty difficulty) {
    size = tableSize;
    cellTable = new List<Cell>();
    var rng = new Random();
    for (int i = 0; i < size * size; i++) {
      var cell = new Cell();
      cell.posX = (i ~/ size).truncate().toInt();
      cell.posY = i % size;
      switch (difficulty) {
        case Difficulty.Easy:
          cell.isBomb = rng.nextInt(100) % 9 == 0;
          break;
        case Difficulty.Medium:
          cell.isBomb = rng.nextInt(100) % 6 == 0;
          break;
        case Difficulty.Hard:
          cell.isBomb = rng.nextInt(100) % 3 == 0;
          break;
      }
      cellTable.add(cell);
    }

    for (int i = 0; i < size * size; i++) {
      cellTable[i].number = cellTable
          .where((element) => element.IsBombNeighbour(sizeToX(i), sizeToY(i)))
          .length;
    }
  }

  void revealEmptyNeighbours(Cell cell) {
    cell.isRevealed = true;
    var neighbours = getEmptyNeighbours(cell);
    for (int i = 0; i < neighbours.length; i++) {
      revealEmptyNeighbours(neighbours[i]);
      neighbours[i].isRevealed = true;

      var cc = getNumberNeighbours(neighbours[i]);
      for (int j = 0; j < cc.length; j++) {
        cc[j].isRevealed = true;
      }
    }
  }

  List<Cell> getNumberNeighbours(Cell cell) {
    return cellTable
        .where((element) => element.IsNumberNeighbour(cell.posX, cell.posY))
        .toList();
  }

  List<Cell> getEmptyNeighbours(Cell cell) {
    return cellTable
        .where((element) => element.IsEmptyNeighbour(cell.posX, cell.posY))
        .toList();
  }

  static int sizeToX(int index) {
    return (index ~/ size).truncate().toInt();
  }

  static int sizeToY(int index) {
    return index % size;
  }

  int count(CellType cellType) {
    switch (cellType) {
      case CellType.Marked:
        return cellTable
            .where((element) => element.isMarked && !element.isRevealed)
            .length;
        break;
      case CellType.Bomb:
        return cellTable.where((element) => element.isBomb).length;
        break;
      case CellType.Exploded:
        return cellTable.where((element) => element.isRevealed && element.isBomb).length;
        break;
      case CellType.UnExplored:
        // Number of cells which are not bombs but have not been explored yet!
        return cellTable.where((element) => !element.isRevealed && !element.isBomb).length;
        break;
      case CellType.Explored:
        return cellTable.where((element) => element.isRevealed).length;
        break;
      default:
        return -1;
    }

  }
}
