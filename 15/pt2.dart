import '../util.dart';
import 'pt1.dart';

enum WideItem {BoxLeft, BoxRight, Wall, Empty}
class WideData {
  List<List<WideItem>> map;
  Vector robotPosition;
  List<Vector> moves;
  WideData(this.map, this.robotPosition, this.moves);
}

WideData getWideData([String inputFileName = "input.txt"]) {
  Data data = getData(inputFileName);
  List<List<WideItem>> wideMap = [];
  for (List<Item> line in data.map) {
    List<WideItem> wideLine = [];
    for (Item item in line) {
      if (item == Item.Box) {
        wideLine.add(WideItem.BoxLeft);
        wideLine.add(WideItem.BoxRight);
      }
      else if (item == Item.Wall) {
        wideLine.add(WideItem.Wall);
        wideLine.add(WideItem.Wall);
      }
      else {
        wideLine.add(WideItem.Empty);
        wideLine.add(WideItem.Empty);
      }
    }
    wideMap.add(wideLine);
  }
  return WideData(wideMap, Vector(data.robotPosition.row, data.robotPosition.col * 2), data.moves);
}

Vector getOtherPosition(List<List<WideItem>> map, Vector position) =>
  map[position.row][position.col] == WideItem.BoxLeft ? 
    Vector(position.row, position.col + 1) :
    Vector(position.row, position.col - 1)
;

bool isPushPossible(List<List<WideItem>> map, Vector position, Vector direction) {
  Vector otherPosition = getOtherPosition(map, position);
  Vector newPosition = position + direction;
  Vector newOtherPosition = otherPosition + direction;

  bool pushThisSide = (
    map[newPosition.row][newPosition.col] == WideItem.Empty || (
      map[newPosition.row][newPosition.col] != WideItem.Wall &&
      isPushPossible(map, newPosition, direction)
    )
  );
  return pushThisSide && (
    map[newOtherPosition.row][newOtherPosition.col] == WideItem.Empty || (
      map[newOtherPosition.row][newOtherPosition.col] != WideItem.Wall &&
      (direction.row == 0 ? pushThisSide : isPushPossible(map, newOtherPosition, direction))
    )
  );
}

void resolvePush(List<List<WideItem>> map, Vector position, Vector direction) {
  if (map[position.row][position.col] == WideItem.Empty) return;

  if (direction.row != 0) {
    Vector otherPosition = getOtherPosition(map, position);
    Vector newOtherPosition = otherPosition + direction;

    resolvePush(map, newOtherPosition, direction);
    map[newOtherPosition.row][newOtherPosition.col] = map[otherPosition.row][otherPosition.col];
    map[otherPosition.row][otherPosition.col] = WideItem.Empty;
  }
  
  Vector newPosition = position + direction;

  resolvePush(map, newPosition, direction);
  map[newPosition.row][newPosition.col] = map[position.row][position.col];
  map[position.row][position.col] = WideItem.Empty;
}

Vector makeWideMove(Vector robotPosition, Vector direction, List<List<WideItem>> map) {
  if (map[robotPosition.row][robotPosition.col] != WideItem.Empty) {
    throw StateError(
      "$robotPosition occupied by robot and ${map[robotPosition.row][robotPosition.col]}"
    );
  }

  Vector newPosition = robotPosition + direction;
  if (map[newPosition.row][newPosition.col] == WideItem.Empty) return newPosition;
  else if (
    (
      map[newPosition.row][newPosition.col] == WideItem.BoxLeft ||
      map[newPosition.row][newPosition.col] == WideItem.BoxRight
    ) && isPushPossible(map, newPosition, direction)
  ) {
    resolvePush(map, newPosition, direction);
    return newPosition;
  }
  else return robotPosition; // newPosition must be wall, no move
}

int sumWideGpsCoordinates(List<List<WideItem>> map) {
  int total = 0;
  for (int row = 1; row < map.length - 1; row++) {
    for (int col = 2; col < map[0].length - 2; col++) {
      if (map[row][col] == WideItem.BoxLeft) {
        total += (100 * row) + col;
      }
    }
  }
  return total;
}

String showMap(List<List<WideItem>> map) =>
  map.map(
    (List<WideItem> line) => line.map(
      (WideItem element) => switch (element) {
        WideItem.BoxLeft => '[',
        WideItem.BoxRight => ']',
        WideItem.Wall => '#',
        WideItem.Empty => '.'
      }
    ).join()
  ).join('\n')
;

void main() {
  WideData data = getWideData();
  // print(showMap(data.map));
  for (Vector move in data.moves) {
    data.robotPosition = makeWideMove(data.robotPosition, move, data.map);
    // print(showMap(data.map));
  }
  // print(showMap(data.map));
  print(sumWideGpsCoordinates(data.map));
}