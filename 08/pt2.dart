import '../util.dart';
import 'pt1.dart';

Set<Vector> findAntinodesRH(List<Vector> nodes, List<String> map) {
  Set<Vector> antinodes = {};
  
  // check all pairs of points exactly once
  for (int i = 0; i < nodes.length; i++) {
    for (int j = i + 1; j < nodes.length; j++) {
      Vector delta = nodes[i] - nodes[j];
      delta ~/= delta.row.gcd(delta.col);

      for (
        Vector candidate = Vector.from(nodes[i]);
        onMap(candidate.row, candidate.col, map.map((line) => line.split("")).toList());
        candidate += delta  
      ) antinodes.add(candidate);
      antinodes.add(Vector.from(nodes[i]));
      for (
        Vector candidate = Vector.from(nodes[i]);
        onMap(candidate.row, candidate.col, map.map((line) => line.split("")).toList());
        candidate -= delta  
      ) antinodes.add(candidate);
    }
  }
  return antinodes;
}

void main() {
  List<String> map = readInput();
  Set<Vector> antinodes = {};
  for (String frequency in frequencies) {
    antinodes.addAll(findAntinodesRH(findNodes(map, frequency), map));
  }
  print(antinodes.length);
}