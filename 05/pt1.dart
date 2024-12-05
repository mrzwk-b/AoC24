import 'dart:io';

class Data {
  Map<int, Set<int>> rules;
  List<List<int>> updates;
  Data(this.rules, this.updates);
}

Data getData([String inputFileName = "input.txt"]) {
  List<String> lines =  File(
    [Directory.current.path, inputFileName].join(Platform.pathSeparator)
  ).readAsLinesSync();

  Map<int, Set<int>> rules = {};
  for (String rule in lines.sublist(0, lines.indexOf(""))) {
    List<int> pageNumbers = rule.split('|').map((String value) => int.parse(value)).toList();
    rules.update(
      pageNumbers[0],
      (Set<int> successors) => successors.union({pageNumbers[1]}),
      ifAbsent: () => {pageNumbers[1]},
    );
  }

  List<List<int>> updates = lines.sublist(lines.indexOf("") + 1, lines.length).map((
    (String update) => update.split(',').map(
      (String page) => int.parse(page)
    ).toList()
  )).toList();

  return Data(rules, updates);
}

bool isInOrder(List<int> update, Map<int, Set<int>> rules) {
  bool valid = true;
  Set<int> seen = {};
  for (int i = 0; i < update.length; i++) {
    if (! seen.intersection(rules[update[i]] ?? {}).isEmpty) {
      valid = false;
      break;
    }
    seen.add(update[i]);
  }
  return valid;
}

int middle(List<int> elements) => elements[elements.length ~/ 2];

void main() {
  Data data = getData();
  Map<int, Set<int>> rules = data.rules;
  List<List<int>> updates = data.updates;

  int total = 0;
  for (List<int> update in updates) {
    if (isInOrder(update, rules)) {
      total += middle(update);
    }
  }

  print(total);
}