import 'pt1.dart';

List<List<bool>> getSidesMap(List<List<bool>> region) {
  bool inRegion = false;
  List<List<bool>> sidesMap = falseFill(region.length, region[0].length);
  for (int row = 0; row < region.length; row++) {
    for (int col = 0; col < region[0].length; col++) {
      if (
        region[row][col] != inRegion ||
        (region[row][col] && col == region[0].length - 1)
      ) {
        inRegion = !inRegion;
        sidesMap[row][col] = true;
      } 
    }
  }
  return sidesMap;
}

int countSides(List<List<bool>> region) {
  int total = 0;
  // look for them separately along horizontal and vertical axes
  
  return total;
}

void main() {  
  print(
    getAllRegions(getData())
    .map((region) => region.area * countSides(region.squares))
    .reduce((a,b)=>a+b)
  );
}