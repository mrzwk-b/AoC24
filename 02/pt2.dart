import 'pt1.dart';

bool compareLevels(a, b, isIncreasing) => 
  (a - b).abs() <= 3 &&
  (a - b).abs() > 0 &&
  ((a - b < 0) == isIncreasing)
;

void main() {
  List<List<int>> data = getData();
  int total = 0;
  for (List<int> line in data) {
    bool? isIncreasing;
    bool isValid = true;
    bool problemFound = false;
    for (int i = 0; i < line.length - 1; i++) {
      // valid comparison
      if (compareLevels(line[i], line[i+1], isIncreasing)) {
        
      }
      // invalid comparison but not problem found
      else if (!problemFound) {
        problemFound = true;
        if ((i > 1) && compareLevels(line[i-1], line[i+1], isIncreasing)) {}
        else {
          isValid = false;
        }
      }
      // invalid comparison and problem found
      else {
        isValid = false;
      }
    }
    if (isValid) {
      total += 1;
    }
  }
  print(total);
}