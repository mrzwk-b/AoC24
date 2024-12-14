import '../util.dart';

List<List<String>> getData() =>
  readInput().map((line) => line.split("")).toList()
;

List<List<bool>> falseFill(int height, int width) => [
  for (int row = 0; row < height; row++) 
    [for (int col = 0; col < width; col++) false]
];

class Region {
  List<List<bool>> squares;
  Region(int height, int width): squares = falseFill(height, width);

  void add(int row, int col) {
    squares[row][col] = true;
  }
  
  int get area => 
    squares.map(
      (line) => line.map(
        (square) => square ? 1:0
      ).reduce((a,b)=>a+b)
    ).reduce((a,b)=>a+b)
  ;
  int get perimeter {
    int total = 0;
    for (int row = 0; row < squares.length; row++) {
      for (int col = 0; col < squares[0].length; col++) {
        Vector currentSquare = Vector(row, col);
        if (squares[currentSquare.row][currentSquare.col]) {
          total += orthogonals.map((dir) {
            Vector next = currentSquare + dir;
            return (onMap(next.row, next.col, squares) && squares[next.row][next.col]) ? 0:1;
          }).reduce((a,b)=>a+b);
        }
      }
    }
    return total;
  }
}

/// DFS on [world] that adds matching squares to [region]
void scanIntoRegion(Region region, List<List> world, Vector locus) {
  region.add(locus.row, locus.col);
  for (Vector dir in orthogonals) {
    Vector next = locus + dir;
    if (
      onMap(next.row, next.col, region.squares) &&
      !region.squares[next.row][next.col] &&
      world[locus.row][locus.col] == world[next.row][next.col]
    ) {
      scanIntoRegion(region, world, next);
    }
  }
}

List<Region> getAllRegions(List<List<String>> world) {
  List<Region> regions = [];
  List<List<bool>> mapped = falseFill(world.length, world[0].length);
  for (int row = 0; row < world.length; row++) {
    for (int col = 0; col < world[0].length; col++) {
      if (!mapped[row][col]) {
        Region region = Region(world.length, world[0].length);
        regions.add(region);
        scanIntoRegion(region, world, Vector(row, col));
        for (int i = 0; i < mapped.length; i++) {
          for (int j = 0; j < mapped[0].length; j++) {
            mapped[i][j] |= region.squares[i][j];
          }
        }
      }
    }
  }
  return regions;
}

void main() {  
  print(
    getAllRegions(getData())
    .map((region) => region.area * region.perimeter)
    .reduce((a,b)=>a+b)
  );
}