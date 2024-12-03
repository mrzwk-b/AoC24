import 'pt1.dart';

void main() {
  String data = getData();

  Map<int, RegExpMatch> multiplications = Map.fromIterable(
    RegExp(r"mul\(\d\d*,\d\d*\)").allMatches(data),
    key: (match) => (match as RegExpMatch).start,
    value: (match) => match
  );

  Map<int, RegExpMatch> dos = Map.fromIterable(
    RegExp(r"do\(\)").allMatches(data),
    key: (match) => (match as RegExpMatch).start,
    value: (match) => match
  );
  
  Map<int, RegExpMatch> donts = Map.fromIterable(
    RegExp(r"don't\(\)").allMatches(data),
    key: (match) => (match as RegExpMatch).start,
    value: (match) => match
  );


  int total = 0;
  bool doInstruction = true;
  for (int i = 0; i < data.length; i++) {
    if (doInstruction && multiplications.containsKey(i)) {
      total += RegExp(r"\d\d*")
        .allMatches(multiplications[i]![0]!)
        .map((x) => int.tryParse(x[0]!)!)
        .reduce((a, b) => a*b)
      ;
    }
    else if (dos.containsKey(i)) {
      doInstruction = true;
    }
    else if (donts.containsKey(i)) {
      doInstruction = false;
    }
  }

  print(total);
}