import 'pt1.dart';

bool hasLoop(List<List<MapElement>> map) {
  List<int> start = guardStart(map);
  int guardRow = start[0];
  int guardCol = start[1];
  MapElement facing = map[guardRow][guardCol];

  while (true) {
    int rowStep = (facing == MapElement.Up) ? -1 : (facing == MapElement.Down) ? 1 : 0;
    int colStep = (facing == MapElement.Left) ? -1 : (facing == MapElement.Right) ? 1 : 0;

    // stepped off map, no loop
    if (!onMap(guardRow + rowStep, guardCol + colStep, map)) return false;

    if (map[guardRow + rowStep][guardCol + colStep] == MapElement.Obstacle) {
      facing = turnRight(facing);
    }
    else {
      map[guardRow][guardCol] = facing;
      guardRow += rowStep;
      guardCol += colStep;
    }

    // position has been reached before while facing same direction, loop found
    if (map[guardRow][guardCol] == facing) return true;
  }
}

void main() {
  List<List<MapElement>> map = getData();
  List<List<MapElement>> path = runPatrol([for (List line in map) List.from(line)]);

  List<int> start = guardStart(map);
  path[start[0]][start[1]] = MapElement.Up;

  int total = 0;
  for (int row = 0; row < map.length; row++) {
    for (int col = 0; col < map.length; col++) {
      if (path[row][col] == MapElement.Visited) {
        map[row][col] = MapElement.Obstacle;
        if (hasLoop([for (List line in map) List.from(line)])) total += 1;
        map[row][col] = MapElement.Empty;
      }
    }
  }

  print(total);
}