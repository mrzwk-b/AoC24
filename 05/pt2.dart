import 'pt1.dart';

List<int> inOrder(List<int> original, Map<int, Set<int>> rules) {
  List<int> sorted = original.sublist(0, 1);
  // build sorted list from original one element at a time
  for (int i = 1; i < original.length; i++) {
    // find appropriate spot for current element
    int insertIndex = sorted.length;
    for (int j = 0; j < sorted.length; j++) {
      if ((rules[sorted[j]] ?? {}).contains(original[i])) {
        insertIndex = j;
        break;
      }
    }
    sorted.insert(insertIndex, original[i]);
  }
  return sorted;
}

void main() {
  Data data = getData();
  Map<int, Set<int>> rules = data.rules;
  List<List<int>> updates = data.updates;

  int total = 0;
  for (List<int> update in updates) {
    if (!isInOrder(update, rules)) {
      total += middle(inOrder(update, rules));
    }
  }

  print(total);
}