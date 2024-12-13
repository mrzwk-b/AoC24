import '../util.dart';

List<List<int>> getData() =>
  readInput().map(
    (item) => item.split("").map(
      (digit) => int.parse(digit)
    ).toList()
  ).toList()
;

List<List<Vector>> getTrails(Vector source, List<List<int>> trailMap, [elevation = 0]) {
  List<List<Vector>> trails = [];
  if (trailMap[source.row][source.col] == 9) trails.add([source]);
  else {
    for (Vector dir in orthogonals) {
      Vector next = source + dir;
      if (
        onMap(next.row, next.col, trailMap) && 
        trailMap[next.row][next.col] == elevation + 1
      ) {
        trails.addAll(
          getTrails(next, trailMap, elevation + 1).map((trail) => [source] + trail)
        );
      }
    }
  }
  return trails;
}

void main() {
  int total = 0;
  List<List<int>> trailMap = getData();
  for (int row = 0; row < trailMap.length; row++) {
    for (int col = 0; col < trailMap[row].length; col++) {
      if (trailMap[row][col] == 0) {
        total += (Set()..addAll(
          getTrails(Vector(row, col), trailMap).map((trail) => trail.last)
        )).length;
      }
    }
  }
  print(total);
}