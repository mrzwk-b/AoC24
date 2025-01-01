import '../util.dart';

enum Item {Box, Wall, Empty}
class Data {
  List<List<Item>> map;
  Vector robotPosition;
  List<Vector> moves;
  Data(this.map, this.robotPosition, this.moves);
}

Data getData([String inputFileName = "input.txt"]) {
  List<String> input = readInput(inputFileName);
  int divider = input.indexOf("");

  // build map and find robot
  List<List<Item>> map = [];
  Vector robotPosition = Vector(-1, -1);
  for (int row = 0; row < divider; row++) {
    map.add([]);
    for (int col = 0; col < input[row].length; col++) {
      if (input[row][col] == '@') {
        robotPosition = Vector(row, col);
      }

      if (input[row][col] == '#') {
        map[row].add(Item.Wall);
      }
      else if (input[row][col] == 'O') {
        map[row].add(Item.Box);
      }
      else {
        map[row].add(Item.Empty);
      }
    }
  }
  
  // read move sequence
  List<Vector> moves = [];
  for (String char in input.sublist(divider + 1).join().split("")) {
    moves.add(orthogonals[const ['^','v','<','>'].indexOf(char)]);
  }

  return Data(map, robotPosition, moves);
}

Vector makeMove(Vector robotPosition, Vector direction, List<List<Item>> map) {
  if (map[robotPosition.row][robotPosition.col] != Item.Empty) {
    throw StateError("$robotPosition occupied by robot and ${map[robotPosition.row][robotPosition.col]}");
  }

  Vector newPosition = robotPosition + direction;
  if (map[newPosition.row][newPosition.col] == Item.Empty) return newPosition;
  else if (map[newPosition.row][newPosition.col] == Item.Box) {
    // find the end of the line of boxes
    for (Vector nextInLine = newPosition + direction; true; nextInLine += direction) {
      if (map[nextInLine.row][nextInLine.col] == Item.Wall) return robotPosition; // no push
      if (map[nextInLine.row][nextInLine.col] == Item.Empty) {
        // rather than pushing each box individually we can modify only the ends
        map[nextInLine.row][nextInLine.col] = Item.Box;
        map[newPosition.row][newPosition.col] = Item.Empty;
        return newPosition;
      }
    }
  }
  else return robotPosition; // newPosition must be wall, no move
}

int sumGpsCoordinates(List<List<Item>> map) {
  int total = 0;
  for (int row = 1; row < map.length; row++) {
    for (int col = 1; col < map[0].length; col++) {
      if (map[row][col] == Item.Box) {
        total += (100 * row) + col;
      }
    }
  }
  return total;
}

void main() {
  Data data = getData();
  Vector robotPosition = data.robotPosition;
  for (Vector move in data.moves) {
    robotPosition = makeMove(robotPosition, move, data.map);
  }
  print(sumGpsCoordinates(data.map));
}