class Vector {
  int row;
  int col;
  Vector(this.row, this.col);
  
  Vector operator +(Vector other) => Vector(row + other.row, col + other.col);
  Vector operator *(int other) => Vector(row * other, col * other);
}