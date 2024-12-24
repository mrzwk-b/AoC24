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
        }
        // below
        if (!(
          onMap(row + 1, col, region) &&
          region[row + 1][col]
        )) {
          sidesMap[row + 1][col] |= 1;
        }
        // left
        if (!(
          onMap(row, col - 1, region) &&
          region[row][col - 1]
        )) {
          sidesMap[row][col] |= 2;
        }
        // right
        if (!(
          onMap(row, col + 1, region) &&
          region[row][col + 1]
        )) {
          sidesMap[row][col + 1] |= 2;
        }
      }
    }
  }
  return sidesMap;
}

int countSides(List<List<int>> sidesMap) {
  int total = 0;
  for (List<int> line in sidesMap) print(line);

  for (int row = 0; row < sidesMap.length; row++) {
    for (int col = 0; col < sidesMap.length; col++) {
      if (
        (sidesMap[row][col] & 1 == 1 ? true : false) && !(
          onMap(row - 1, col, sidesMap) && 
          (sidesMap[row - 1][col] & 1 == 1 ? true : false)
        )
      ) {
        total += 1;
      }
      if (
        (sidesMap[row][col] & 2 == 2 ? true : false) && !(
          onMap(row, col - 1, sidesMap) && 
          (sidesMap[row][col - 1] & 2 == 2 ? true : false)
        )
      ) {
        total += 1;
      }
    } 
  }

  print("$total\n");
  return total;
}

void main() {  
  print(
    getAllRegions(getData())
    .map((region) => region.area * countSides(getSidesMap(region.squares)))
    .reduce((a,b)=>a+b)
  );
}