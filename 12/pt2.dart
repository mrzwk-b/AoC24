import '../util.dart';
import 'pt1.dart';

/// horizontal sides are true in 1s place,
/// vertical sides are true in 2s place
List<List<int>> getSidesMap(List<List<bool>> region) {
  List<List<int>> sidesMap = [
    for (int i = 0; i < region.length + 1; i++) [
      for (int j = 0; j < region[0].length + 1; j++)
        0
    ]
  ];
  for (int row = 0; row < region.length; row++) {
    for (int col = 0; col < region[0].length; col++) {
      if (region[row][col]) {
        // above
        if (!(
          onMap(row - 1, col, region) &&
          region[row - 1][col]
        )) {
          sidesMap[row][col] |= 1;
          sidesMap[row][col + 1] |= 1;
        }
        // below
        if (!(
          onMap(row + 1, col, region) &&
          region[row + 1][col]
        )) {
          sidesMap[row + 1][col] |= 1;
          sidesMap[row + 1][col + 1] |= 1;
        }
        // left
        if (!(
          onMap(row, col - 1, region) &&
          region[row][col - 1]
        )) {
          sidesMap[row][col] |= 2;
          sidesMap[row + 1][col] |= 2;
        }
        // right
        if (!(
          onMap(row, col + 1, region) &&
          region[row][col + 1]
        )) {
          sidesMap[row][col + 1] |= 2;
          sidesMap[row + 1][col + 1] |= 2;
        }
      }
    }
  }
  return sidesMap;
}

int countSidesInHorizontalLine(List<List<bool>> sidesMap) {
  int total = 0;
  for (int row = 0; row < sidesMap.length; row++) {
    bool inSide = false;
    for (int col = 0; col < sidesMap[0].length; col++) {
      if (sidesMap[row][col]) {
        if (!inSide) {
          total += 1;
        }
        inSide = true;
      }
      else {
        inSide = false;
      }
    }
  }
  return total;
}

int countSidesInVerticalLine(List<List<bool>> sidesMap) {
  int total = 0;
  for (int col = 0; col < sidesMap[0].length; col++) {
    bool inSide = false;
    for (int row = 0; row < sidesMap[0].length; row++) {
      if (sidesMap[row][col]) {
        if (!inSide) {
          total += 1;
        }
        inSide = true;
      }
      else {
        inSide = false;
      }
    }
  }
  return total;
}

int countSides(List<List<bool>> region) {
  List<List<bool>> tops = falseFill(region.length, region[0].length);
  List<List<bool>> bottoms = falseFill(region.length, region[0].length);
  List<List<bool>> lefts = falseFill(region.length, region[0].length);
  List<List<bool>> rights = falseFill(region.length, region[0].length);
  
  // find all sides of [region]
  for (int row = 0; row < region.length; row++) {
    for (int col = 0; col < region.length; col++) {
      if (region[row][col]) {
        if (!(onMap(row - 1, col, region) && region[row - 1][col])) {
          tops[row][col] = true;
        }
        if (!(onMap(row + 1, col, region) && region[row + 1][col])) {
          bottoms[row][col] = true;
        }
        if (!(onMap(row, col - 1, region) && region[row][col - 1])) {
          lefts[row][col] = true;
        }
        if (!(onMap(row, col + 1, region) && region[row][col + 1])) {
          rights[row][col] = true;
        }
      }
    }
  }

  return
    countSidesInHorizontalLine(tops) + 
    countSidesInHorizontalLine(bottoms) +
    countSidesInVerticalLine(lefts) + 
    countSidesInVerticalLine(rights)
  ;
}

void main() {  
  print(
    getAllRegions(getData())
    .map((region) => region.area * countSides(region.squares))
    .reduce((a,b)=>a+b)
  );
}