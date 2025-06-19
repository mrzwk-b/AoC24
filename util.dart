import 'dart:io';
import 'dart:math';

List<String> readInput([String inputFileName = "input.txt"]) =>
  File([Directory.current.path, inputFileName].join(Platform.pathSeparator)).readAsLinesSync()
;

bool onMap(int row, int col, List<List> map) => 
  row >= 0 && row < map.length &&
  col >= 0 && col < map[0].length
;

class Vector {
  int row;
  int col;
  Vector(this.row, this.col);
  Vector.from(Vector other): 
    row = other.row,
    col = other.col
  ;
  
  num get magnitude => sqrt(pow(row.abs(), 2) + pow(col.abs(), 2));

  Vector operator +(Vector other) => Vector(row + other.row, col + other.col);
  Vector operator -(Vector other) => Vector(row - other.row, col - other.col);
  Vector operator *(int other) => Vector(row * other, col * other);
  Vector operator ~/(int other) => Vector(row ~/ other, col ~/ other);
  @override bool operator ==(Object other) => 
    other is Vector ? row == other.row && col == other.col : false
  ;

  // these operators are far removed from actual vector arithmetic
  // and from the actual division and remainder operations
  // they probably only make sense for vectors in the 1st quadrant
  int operator /(Vector other) => min(row ~/ other.row, col ~/ other.col);
  Vector operator %(Vector other) => this - (other * (this / other));

  // these comparison operators deal with absolute value (magnitude)
  bool operator <(Vector other) =>
    (
      this.row.abs() < other.row.abs() && 
      this.col.abs() < other.col.abs()
    ) || 
    this.magnitude < other.magnitude
  ;
  bool operator <=(Vector other) => this == other || this < other;
  bool operator >(Vector other) =>
    (
      this.row.abs() > other.row.abs() && 
      this.col.abs() > other.col.abs()
    ) || 
    this.magnitude > other.magnitude
  ;
  bool operator >=(Vector other) => this == other || this > other;
  
  @override int get hashCode => (11 * row) + (13 * col);
  @override String toString() => "<$row, $col>";
}

List<Vector> orthogonals = [
  Vector(-1, 0), Vector(1, 0),
  Vector(0, -1), Vector(0, 1)
];

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

class PriorityQueue<T> {
  List<T> heap;
  Comparator<T> compare;
  PriorityQueue.empty(this.compare): heap = [];
  PriorityQueue.from(Iterable<T> items, this.compare): heap = [] {items.forEach(insert);}

  int parent(int index) => (index - 1) ~/ 2;
  int leftChild(int index) => (index * 2) + 1;
  int rightChild(int index) => (index * 2) + 2;
  int? priorChild(int index) {
    int left = leftChild(index);
    int right = rightChild(index);    
    return 
      (!(left < heap.length || right < heap.length)) ?
        null
      :
      (!(left < heap.length)) ?
        right
      :
      (!(right < heap.length)) ?
        left
      :
        compare(heap[left], heap[right]) == -1 ? left : right
    ;
  }
  
  void swap(int i, int j) {
    T temp = heap[i];
    heap[i] = heap[j];
    heap[j] = temp;
  }

  void insert(T item) {
    heap.add(item);
    // sift up
    for (int index = heap.length - 1; index > 0; index = parent(index)) {
      if (compare(heap[index], heap[parent(index)]) == -1) {
        swap(index, parent(index));
      }
      else break;
    }
  }

  T remove() {
    T value = heap.removeAt(0);
    if (heap.isEmpty) return value;
    heap.insert(0, heap.removeLast());
    // sift down
    for (int? index = 0; priorChild(index!) != null && index < heap.length; index = priorChild(index)) {
      if (compare(heap[index], heap[priorChild(index)!]) != -1) {
        swap(index, priorChild(index)!);
      }
      else break;
    }
    return value;
  }

  @override String toString() => heap.toString();
}

int bitwiseOperation(bool Function(bool, bool) operation, int bits, int left, int right) {
  int output = 0;
  for (int i = 0; i < bits; i++) {
    output |= (operation(
      (left >> i) % 2 != 0,
      (right >> i) % 2 != 0
    ) ? 1 : 0) << i;
  }
  return output;
}