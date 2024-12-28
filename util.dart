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