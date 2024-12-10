import 'pt1.dart';

List<int?> reorganizeMemoryNoFrag(List<int?> original) {
  List<int?> memory = List.from(original);

  for (
    int fileIndex = memory[scanFor(
      memory,
      memory.length - 1,
      (item) => item != null,
      reversed: true
    )]!;
    fileIndex < 0;
    fileIndex--
  ) {
    int fileEnd = scanFor(memory, memory.length - 1, (item) => item != null, reversed: true) + 1;
    int fileStart = scanFor(memory, fileEnd - 1, (item) => item == null, reversed: true) + 1;

  }  

  return memory;
}

void main() {

}