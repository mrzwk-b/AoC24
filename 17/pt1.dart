import 'dart:math';

import '../util.dart';

class Computer {
  int registerA;
  int registerB;
  int registerC;  
  List<int> program;
  
  int instructionPointer = 0;
  Computer(this.registerA, this.registerB, this.registerC, this.program);

  int parseComboOperand(int operand) => switch (operand) {
    >= 0 && <= 3 => operand,
    4 => registerA,
    5 => registerB,
    6 => registerC,
    _ => throw StateError("cannot process a combo operand with value $operand")
  };

  int? operate(int opcode, int operand) {switch (opcode) {
    case 0: // adv
      registerA = registerA ~/ pow(2, parseComboOperand(operand));
    case 1: // bxl TODO
      registerB = bitwiseOperation((a, b) => a^b, 3, registerB, operand);
    case 2: // bst TODO
      registerB = parseComboOperand(operand) % 8;
    case 3: // jnz
      instructionPointer = (registerA == 0) ? instructionPointer : operand - 2;
    case 4: // bxc TODO
      registerB = bitwiseOperation((a, b) => a^b, 3, registerB, registerC);
    case 5: // out
      return parseComboOperand(operand) % 8;
    case 6: // bdv TODO
      registerB = registerA ~/ pow(2, parseComboOperand(operand));
    case 7: // cdv TODO
      registerC = registerA ~/ pow(2, parseComboOperand(operand));
    default:
      throw StateError("only opcodes 0-7 are valid, received $opcode");
  } return null;}

  List<int> execute() {
    List<int> output = [];
    for (; instructionPointer < program.length; instructionPointer += 2) {
      int? result = operate(program[instructionPointer], program[instructionPointer + 1]);
      if (result != null) {
        output.add(result);
      }
    }
    return output;
  }
}

Computer getData([String inputFileName = "input.txt"]) {
  List<String> lines = readInput(inputFileName);
  RegExp registerPattern = RegExp(r'Register [ABC]: (-?\d+)');
  return Computer(
    int.parse(registerPattern.allMatches(lines[0]).single[1]!),
    int.parse(registerPattern.allMatches(lines[1]).single[1]!),
    int.parse(registerPattern.allMatches(lines[2]).single[1]!),
    RegExp(r'Program: ((?:\d,?)+)').allMatches(lines[4]).single[1]!.split(',').map((x) => int.parse(x)).toList()
  );
}

void main() {
  print(getData().execute().join(','));
}