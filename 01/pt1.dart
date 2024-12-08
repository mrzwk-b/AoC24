import '../util.dart';

String inputFileName = "input.txt";

List<List<int>> getData() {
  List<String> lines = readInput();
  List<List<int>> data = [[], []];
  for (String line in lines) {
    List<int> lr = line.split('   ').map((String item) => int.parse(item)).toList();
    data[0].add(lr[0]);
    data[1].add(lr[1]);
  }
  return data;
}

void main() {
  List<List<int>> data = getData();
  data[0].sort((int a, int b) => a.compareTo(b));
  data[1].sort((int a, int b) => a.compareTo(b));

  int total = 0;
  for (int i = 0; i < data[0].length; i++) {
    total += (data[0][i] - data[1][i]).abs();
  }
  print(total);
}