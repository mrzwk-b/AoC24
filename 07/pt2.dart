import 'pt1.dart';

void main() {
  List<Equation> data = getData();

  int total = 0;
  for (Equation eq in data) {
    if (isPossible(eq.result, eq.operands, [
      (a, b) => int.parse(a.toString() + b.toString()),
      (a, b) => a * b,
      (a, b) => a + b,
    ])) total += eq.result;
  }
  print(total);
}