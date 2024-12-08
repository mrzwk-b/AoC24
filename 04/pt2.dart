import '../util.dart';

Set<String> corners = {'S', 'M'};

bool mas(String a, String b) => corners.contains(a) && corners.contains(b) && a != b;

void main() {
  List<String> data = readInput();
  int total = 0;

  int height = data.length;
  int width = data[0].length;
  // iterate over basically each space
  // excluding edges because they can't be the center of an X
  for (int row = 1; row < height - 1; row++) {
    for (int col = 1; col < width - 1; col++) {
      if (
        data[row][col] == 'A' &&
        mas(data[row-1][col-1], data[row+1][col+1]) &&
        mas(data[row-1][col+1], data[row+1][col-1])
      ) {
        total += 1;
      }
    }
  }

  print(total);
}