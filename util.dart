import 'dart:io';

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
  
  bool operator ==(Object other) => other is Vector ? row == other.row && col == other.col : false;
  Vector operator +(Vector other) => Vector(row + other.row, col + other.col);
  Vector operator -(Vector other) => Vector(row - other.row, col - other.col);
  Vector operator *(int other) => Vector(row * other, col * other);
}