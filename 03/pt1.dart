import 'dart:io';

String getData([String inputFileName = "input.txt"]) =>
  File([Directory.current.path, inputFileName].join('\\')).readAsStringSync()
;

void main() {
  String data = getData();
  RegExp pattern = RegExp(r"mul\(\d\d*,\d\d*\)");

  int total = 0;
  for (RegExpMatch match in pattern.allMatches(data)) {
    total += RegExp(r"\d\d*").allMatches(match[0]!).map((x) => int.tryParse(x[0]!)!).reduce((a, b) => a*b);
  }

  print(total);
}