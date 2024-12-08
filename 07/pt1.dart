import '../util.dart';

class Equation {
  int result;
  List<int> operands;
  Equation(this.result, this.operands);
}

List<Equation> getData([String inputFileName = "input.txt"]) =>
  readInput().map(
    (String line) => Equation(
      int.parse(line.split(':')[0]), 
      line.split(' ').sublist(1).map((String number) => int.parse(number)).toList()
    ) 
  ).toList()
;

bool isPossible(int target, List<int> operands, List<int Function(int, int)> operators) {
  if (operands.isEmpty) return false;
  if (operands.length == 1) return operands[0] == target;
  
  for (int Function(int, int) op in operators) {
    if (isPossible(
      target,
      operands.sublist(2)..insert(0, op(operands[0], operands[1])),
      operators
    )) return true;
  }
  return false;
}

void main() {
  List<Equation> data = getData();

  int total = 0;
  for (Equation eq in data) {
    if (isPossible(eq.result, eq.operands, [
      (a, b) => a * b,
      (a, b) => a + b,
    ])) total += eq.result;
  }
  print(total);
}
