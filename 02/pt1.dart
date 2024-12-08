import '../util.dart';

List<List<int>> getData([String inputFileName = "input.txt"]) {
  List<String> lines = readInput();
  List<List<int>> data = [];
  for (String line in lines) {
    data.add(line.split(' ').map((x) => int.parse(x)).toList());
  }
  return data;
}

bool isValid(List<int> report) {
  bool isIncreasing = (report[0] - report[1]) < 0;
  bool valid = true;
  for (int i = 0; i < report.length - 1; i++) {
    valid &= (
      (report[i] - report[i + 1]).abs() <= 3 &&
      (report[i] - report[i + 1]).abs() > 0 &&
      ((report[i] - report[i + 1] < 0) == isIncreasing)
    );
  }
  return valid;
}

void main() {
  List<List<int>> data = getData();
  int total = 0;
  for (List<int> report in data) {
    if (isValid(report)) {
      total += 1;
    }
  }
  print(total);
}