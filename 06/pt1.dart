import 'dart:io';

enum MapElement {
  Empty, Obstacle, Visited, 
  Up, Down, Left, Right
}

List<List<MapElement>> getData([String inputFileName = "input.txt"]) =>
  File([Directory.current.path, inputFileName].join(Platform.pathSeparator)).readAsLinesSync().map(
    (String line) => line.split("").map(
      (String char) => 
        char == '#' ? MapElement.Obstacle :
        char == '^' ? MapElement.Up : 
        char == '.' ? MapElement.Empty : 
        (){throw ArgumentError("expected '#', '^', or '.', not '$char'");}()
    ).toList()
  ).toList()
;

int countVisited(List<List<MapElement>> map) {
  int total = 0;
  for (List<MapElement> line in map) {
    for (MapElement tile in line) {
      if (tile == MapElement.Visited) {
        total += 1;
      }
    }
  }
  return total;
}

MapElement turnRight(MapElement facing) =>
  (facing == MapElement.Up) ? MapElement.Right :
  (facing == MapElement.Right) ? MapElement.Down :
  (facing == MapElement.Down) ? MapElement.Left :
  (facing == MapElement.Left) ? MapElement.Up :
  (){throw ArgumentError("turnRight doesn't accept ${facing}");}()
;

bool onMap(int row, int col, List<List> map) => 
  row >= 0 && row < map.length &&
  col >= 0 && col < map[0].length
;

List<int> guardStart(List<List<MapElement>> map) {
  int guardRow = map.indexWhere((List<MapElement> line) => line.contains(MapElement.Up));
  return [guardRow, map[guardRow].indexWhere((MapElement tile) => tile == MapElement.Up)];
}

List<List<MapElement>> runPatrol(List<List<MapElement>> map) {
  List<int> start = guardStart(map);
  int guardRow = start[0];
  int guardCol = start[1];
    
  bool patrolling = true;
  while (patrolling) {
    MapElement facing = map[guardRow][guardCol];
    int rowStep = (facing == MapElement.Up) ? -1 : (facing == MapElement.Down) ? 1 : 0;
    int colStep = (facing == MapElement.Left) ? -1 : (facing == MapElement.Right) ? 1 : 0;

    bool stepOnMap = onMap(guardRow + rowStep, guardCol + colStep, map);
    if (stepOnMap && map[guardRow + rowStep][guardCol + colStep] == MapElement.Obstacle) {
      map[guardRow][guardCol] = turnRight(facing);
    }
    else {
      map[guardRow][guardCol] = MapElement.Visited;
      guardRow += rowStep;
      guardCol += colStep;
      if (stepOnMap) {
        map[guardRow][guardCol] = facing;
      }
      else {
        patrolling = false;
      }
    }
  }

  return map;
}

void main() {
  print(countVisited(runPatrol(getData())));
}
