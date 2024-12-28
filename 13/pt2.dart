import '../util.dart';
import 'pt1.dart';


List<Machine> getDataWithOffset([String inputFileName = "input.txt"]) {
  int offset = 10000000000000;
  List<String> source = readInput(inputFileName);
  return [for (int line = 0; line < source.length; line += 4) 
    Machine(
      Vector(
        int.parse(RegExp(r"X\+\d+").stringMatch(source[line])!.substring(2)),
        int.parse(RegExp(r"Y\+\d+").stringMatch(source[line])!.substring(2))
      ),
      Vector(
        int.parse(RegExp(r"X\+\d+").stringMatch(source[line+1])!.substring(2)),
        int.parse(RegExp(r"Y\+\d+").stringMatch(source[line+1])!.substring(2))
      ),
      Vector(
        int.parse(RegExp(r"X=\d+").stringMatch(source[line+2])!.substring(2)) + offset,
        int.parse(RegExp(r"Y=\d+").stringMatch(source[line+2])!.substring(2)) + offset
      )
    )
  ];
}

Combination? prizeCombinationOptimized(Machine machine) {
  num bPresses = (
    (machine.buttonA.col * machine.prize.row) -
    (machine.prize.col * machine.buttonA.row)
  ) / (
    (machine.buttonA.col * machine.buttonB.row) -
    (machine.buttonB.col * machine.buttonA.row)
  );
  num aPresses = 
    (
      machine.prize.col - 
      (bPresses * machine.buttonB.col)
    ) / 
    machine.buttonA.col
  ;

  if (aPresses % 1 == 0 && bPresses % 1 == 0) {
    return Combination(aPresses.toInt(), bPresses.toInt());
  }
  return null;
}

void main() {
  print(getDataWithOffset().map(
    (machine) => (
      ((Combination combo) => 
        (3 * combo.aPresses) + combo.bPresses
      )(prizeCombinationOptimized(machine) ?? Combination(0, 0))
    )
  ).reduce((a,b)=>a+b));
}