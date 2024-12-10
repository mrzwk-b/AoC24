import '../util.dart';
import 'pt1.dart';

void main() {
  int total = 0;
  List<List<int>> trailMap = getData();
  for (int row = 0; row < trailMap.length; row++) {
    for (int col = 0; col < trailMap[row].length; col++) {
      if (trailMap[row][col] == 0) {
        total += getTrails(Vector(row, col), trailMap).map((trail) => trail.last).length;
      }
    }
  }
  print(total);
}