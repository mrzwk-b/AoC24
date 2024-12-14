import 'pt1.dart';

int countSides(List<List<bool>> region) {
  int total = 0;

  return total;
}

void main() {  
  print(
    getAllRegions(getData())
    .map((region) => region.area * countSides(region.squares))
    .reduce((a,b)=>a+b)
  );
}