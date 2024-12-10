import 'pt1.dart';

/// doesn't behave like normal binary search in that
/// if [target] doesn't exist it still returns
/// the index at which it should be inserted
int binarySearch(List<int> list, int target) =>
  list.isEmpty ? 
    0
  :
  list[list.length ~/ 2] > target ? 
    binarySearch(list.sublist(0, list.length ~/ 2), target) 
  :
  list[list.length ~/ 2] < target ? 
    (list.length ~/ 2) + 1 +
    binarySearch(list.sublist((list.length ~/ 2) + 1), target)
  :
    list.length ~/ 2
;

class SpaceTracker {
  List<int> starts;
  List<int> ends;
  SpaceTracker(List tracked): starts = [], ends = [] {
    for (int i = 0; i < tracked.length;) {
      i = scanFor(tracked, i, (item) => item == null);
      starts.add(i);
      i = scanFor(tracked, i, (item) => item != null);
      ends.add(i);
    }
    if (starts.last == ends.last) {
      starts.removeLast();
      ends.removeLast();
    }
  }

  int findSlotStart(int size, int latest) {
    for (int i = 0; i < starts.length && starts[i] <= latest; i++) {
      if (ends[i] - starts[i] >= size) {
        return starts[i];
      }
    }
    return -1;
  }

  void reflectMove(int oldStart, int newStart, int size) {
    int index;
    // insert or expand block at oldStart
    index = binarySearch(starts, oldStart);
    if (index == starts.length || oldStart + size != starts[index]) {
      starts.insert(index, oldStart);
      ends.insert(index, oldStart + size);  
    }
    else {
      starts[index] = oldStart;
    }
    if (index != 0 && starts[index] == ends[index - 1]) {
      starts.removeAt(index);
      ends.removeAt(index - 1);
    }
    // delete or shrink block at newStart
    index = binarySearch(starts, newStart);
    if (newStart + size == ends[index]) {
      starts.removeAt(index);
      ends.removeAt(index);
    }
    else {
      starts[index] += size;
    }
  }
}

T filter<T>(T suspect, bool Function(T) validator, T replacement) => 
  validator(suspect) ? suspect : replacement
;

bool inRange(int value, int start, int end) => value >= start && value < end;

List<int?> reorganizeMemoryNoFrag(List<int?> original) {
  List<int?> memory = List.from(original);
  SpaceTracker spaceTracker = SpaceTracker(memory);

  for (int index = memory.length - 1; index > 0; ) {
    // find file start and end
    int fileEnd = filter(
      scanFor(memory, index, (item) => item != null, reversed: true) + 1,
      (value) => inRange(value, 0, memory.length),
      memory.length
    );
    int fileNumber = memory[fileEnd - 1]!;
    int fileStart = filter(
      scanFor(memory, fileEnd - 1, (item) => item != fileNumber, reversed: true) + 1,
      (value) => inRange(value, 0, memory.length),
      0
    );
    int size = fileEnd - fileStart;
    // find adequate empty space
    int newStart = spaceTracker.findSlotStart(size, fileStart);
    // move the file
    if (newStart != -1) {
      for (int i = newStart; i < newStart + size; i++) {
        memory[i] = fileNumber;
      }
      for (int i = fileStart; i < fileEnd; i++) {
        memory[i] = null;
      }
      spaceTracker.reflectMove(fileStart, newStart, size);
    }

    index = fileStart - 1;
  }  

  return memory;
}

void main() {
  print(getChecksum(reorganizeMemoryNoFrag(getMemory(getData()))));
}