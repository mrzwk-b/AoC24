import 'dart:io';

String inputFileName = "input.txt";

List<List<int>> getData() {
  List<String> lines = File([Directory.current.path, inputFileName].join('\\')).readAsLinesSync();
  List<List<int>> data = [];
  for (String line in lines) {
    data.add(line.split(' ').map((x) => int.parse(x)).toList());
  }
  return data;
}

void main() {
  List<List<int>> data = getData();
  int total = 0;
  for (List<int> line in data) {
    bool isIncreasing = (line[0] - line[1]) < 0;
    bool isValid = true;
    for (int i = 0; i < line.length - 1; i++) {
      isValid &= (
        (line[i] - line[i + 1]).abs() <= 3 &&
        (line[i] - line[i + 1]).abs() > 0 &&
        ((line[i] - line[i + 1] < 0) == isIncreasing)
      );
    }
    if (isValid) {
      total += 1;
    }
  }
  print(total);
}