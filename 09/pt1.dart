import 'dart:io';

String getData([String inputFileName = "input.txt"]) =>
  File([Directory.current.path, inputFileName].join(Platform.pathSeparator)).readAsStringSync()
;

List<int?> getMemory(String diskMap) {
  List<int?> memory = [];
  int fileIndex = 0;
  bool isCurrentlyFile = true;
  for (String char in diskMap.split("")) {
    if (isCurrentlyFile) {
      memory.addAll([for (int i = 0; i < (int.tryParse(char) ?? 0); i++) fileIndex]);
      fileIndex += 1;
    }
    else {
      memory.addAll([for (int i = 0; i < (int.tryParse(char) ?? 0); i++) null]);
    }
    isCurrentlyFile = ! isCurrentlyFile;
  }
  return memory;
}

int scanFor<T>(List<T> items, int start, bool Function(T) condition, {bool reversed = false}) {
  int index = start;
  for (
    ;
    (index >= items.length && !reversed) || (index == 0 && reversed) ? false : 
      !condition(items[index])
    ;
    reversed ? index-- : index++
  ) {}
  return index;
}

List<int?> reorganizeMemory(List<int?> original) {
  List<int?> memory = List.from(original);
  int leftIndex = scanFor(memory, 0, (item) => item == null);
  for (int rightIndex = memory.length - 1; rightIndex > leftIndex; rightIndex--) {
    if (memory[rightIndex] != null) {
      memory[leftIndex] = memory[rightIndex];
      memory[rightIndex] = null;
    }
    leftIndex = scanFor(memory, leftIndex, (item) => item == null);
  }
  return memory;
}

int getChecksum(List<int?> memory) {
  int total = 0;
  for (int i = 0; i < memory.length; i++) {
    total += (memory[i] ?? 0) * i;
  }
  return total;
}

void main() {
  print(getChecksum(reorganizeMemory(getMemory(getData()))));
}