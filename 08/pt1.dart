import '../util.dart';

List<String> frequencies = [
  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
  '0','1','2','3','4','5','6','7','8','9'
];

List<Vector> findNodes(List<String> map, String frequency) {
  List<Vector> nodes = [];

  for (int row = 0; row < map.length; row++) {
    for (int col = 0; col < map[0].length; col++) {

      if (map[row][col] == frequency) {
        nodes.add(Vector(row, col));
      }

    }
  }
  return nodes;
}

Set<Vector> findAntinodes(List<Vector> nodes, List<String> map) {
  Set<Vector> antinodes = {};
  
  // check all pairs of points exactly once
  for (int i = 0; i < nodes.length; i++) {
    for (int j = i + 1; j < nodes.length; j++) {
      Vector delta = nodes[i] - nodes[j];
      Vector candidate;
      // point on nodes[i] side
      candidate = nodes[i] + delta;
      if (onMap(candidate.row, candidate.col, map.map((String line) => line.split("")).toList())) {
        antinodes.add(Vector.from(candidate));
      }
      // point on nodes[j] side
      candidate = nodes[j] - delta;
      if (onMap(candidate.row, candidate.col, map.map((String line) => line.split("")).toList())) {
        antinodes.add(Vector.from(candidate));
      }
    }
  }
  return antinodes;
}

void main() {
  List<String> map = readInput();
  Set<Vector> antinodes = {};
  for (String frequency in frequencies) {
    antinodes = antinodes.union(findAntinodes(findNodes(map, frequency), map));
  }
  print(antinodes.length);
}