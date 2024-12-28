import '../util.dart';

class Machine {
  Vector buttonA;
  Vector buttonB;
  Vector prize;
  Machine(this.buttonA, this.buttonB, this.prize);
}

class Combination {
  int aPresses;
  int bPresses;
  Combination(this.aPresses, this.bPresses);
}

List<Machine> getData([String inputFileName = "input.txt"]) {
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
        int.parse(RegExp(r"X=\d+").stringMatch(source[line+2])!.substring(2)),
        int.parse(RegExp(r"Y=\d+").stringMatch(source[line+2])!.substring(2))
      )
    )
  ];
}

Combination? prizeCombination(Machine machine) {
  int maxAPresses = 0;
  while ((machine.buttonA * maxAPresses) < machine.prize) maxAPresses++;
  if (machine.buttonA * maxAPresses == machine.prize) return Combination(maxAPresses, 0);
  int maxBPresses = 0;
  while ((machine.buttonB * maxBPresses) < machine.prize) maxBPresses++;
  if (machine.buttonB * maxBPresses == machine.prize) return Combination(0, maxBPresses);

  for (
    int aPresses = maxAPresses;
    aPresses >= 0 && machine.buttonA * aPresses != machine.prize;
    aPresses--
  ) {
    int bPresses = maxBPresses;
    for (;
      bPresses >= 0 && (
        machine.buttonA * aPresses + 
        machine.buttonB * bPresses != 
        machine.prize
      );
      bPresses--
    );
    if (
      machine.buttonA * aPresses + 
      machine.buttonB * bPresses == 
      machine.prize
    ) return Combination(aPresses, bPresses);
  }
  return null;
}

void main() {
  print(getData().map(
    (machine) => (
      ((Combination combo) => 
        (3 * combo.aPresses) + combo.bPresses
      )(prizeCombination(machine) ?? Combination(0, 0))
    )
  ).reduce((a,b)=>a+b));
}