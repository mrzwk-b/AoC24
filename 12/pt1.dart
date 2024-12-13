import '../util.dart';

List<List<String>> getData() =>
  readInput().map((line) => line.split("")).toList()
;

class Region {
  List<List<bool>> elements;
  Region(int height, int width):
    elements = List.filled(height, List.filled(width, false))
  ;

  void add(int row, int col) {
    elements[row][col] = true;
  }
  
  int get area => 
    elements.map(
      (line) => line.map(
        (tile) => tile ? 1:0
      ).reduce((a,b)=>a+b)
    ).reduce((a,b)=>a+b)
  ;
  int get perimeter => 
    0 // TODO
  ;
}

void scanForRegion<T>(Region region, List<List<T>> world, Vector next) {

}

void main() {

}