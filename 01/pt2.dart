import 'pt1.dart';

void main() {
  List<List<int>> data = getData();
  Set<int> left = Set.from(data[0]);
  Map<int, int> counts = {};

  for (int item in data[1]) {
    if (left.contains(item)) {
      counts[item] = counts.putIfAbsent(item, () => 0) + 1;
    }
  }

  int total = 0;
  for (MapEntry<int, int> item in counts.entries) {
    total += item.key * item.value;
  }
  print(total);
}