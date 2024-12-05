import 'dart:io';

List<String> getData([String inputFileName = "input.txt"]) {
  return File([Directory.current.path, inputFileName].join(Platform.pathSeparator)).readAsLinesSync();
}

String word = "XMAS";

class Vector {
  int row;
  int col;
  Vector(this.row, this.col);
  
  Vector operator +(Vector other) => Vector(row + other.row, col + other.col);
  Vector operator *(int other) => Vector(row * other, col * other);
}

void main() {
  List<String> data = getData();
  int total = 0;

  int height = data.length;
  int width = data[0].length;
  // iterate over each space of the word search (word can start anywhere)
  for (int row = 0; row < height; row++) {
    for (int col = 0; col < width; col++) {
      Vector wordStart = Vector(row, col);
      // iterate over each direction the word can go in
      for (Vector direction in [
        Vector(-1, -1), Vector(-1, 0), Vector(-1, 1),
        Vector(0, -1),                 Vector(0, 1),
        Vector(1, -1),  Vector(1, 0),  Vector(1, 1),
      ]) {
        bool found = true;
        // scan direction for the word
        for (int i = 0; i < 4; i++) {
          Vector currentSpace = wordStart + (direction * i);
          if (
            currentSpace.row < 0 || currentSpace.row >= height ||
            currentSpace.col < 0 || currentSpace.col >= width ||
            data[currentSpace.row][currentSpace.col] != word[i]
          ) {
            found = false;
            break;
          }
        }
        if (found) {
          total += 1;
        }
      }
    }
  }

  print(total);
}