import 'pt1.dart';

class InitSearchComputer extends Computer {
  InitSearchComputer(Computer computer):
    super(computer.registerA, computer.registerB, computer.registerC, computer.program)
  ;

  @override
  List<int> execute() {
    List<int> output = [];
    for (; instructionPointer < program.length; instructionPointer += 2) {
      int? result = operate(program[instructionPointer], program[instructionPointer + 1]);
      if (result != null) {
        if (program.length == output.length || result != program[output.length]) {
          return [];
        }
        output.add(result);
      }
    }
    return output;
  }
}

void main() {
  InitSearchComputer computer = InitSearchComputer(getData('test.txt'));
  for (int i = 0; ; i++) {
    computer.registerA = i;
    computer.registerB = 0;
    computer.registerC = 0;

    if (computer.execute().isNotEmpty) {
      print(i);
      break;
    }
  }
}