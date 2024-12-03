import 'pt1.dart';

void main() {
  List<List<int>> data = getData();
  int total = 0;
  for (List<int> report in data) {

    List<int> differences = [];
    int delta = 0;
    for (int i = 1; i < report.length; i++) {
      int difference = report[i] - report[i-1];
      differences.add(difference);
      delta += difference.sign;
    }
    bool isIncreasing = delta > 0;

    int problemIndex = -1;
    for (int i = 0; i < differences.length; i++) {
      if (
        (differences[i] == 0) ||
        (differences[i].abs() > 3) ||
        (differences[i] > 0 != isIncreasing)  
      ) {
        problemIndex = i;
      }
    }

    if (problemIndex != -1) {
      int removed;
      // report[i]
      removed = report.removeAt(problemIndex);
      if (isValid(report)) {
        total += 1;
      }
      // report[i+1]
      else {
        report.insert(problemIndex, removed);
        removed = report.removeAt(problemIndex + 1);
        if (isValid(report)) {
          total += 1;
        }
        else {
        }
        report.insert(problemIndex + 1, removed);
      }
    }
    else {
      total += 1;
    }

  }
  
  print(total);
}