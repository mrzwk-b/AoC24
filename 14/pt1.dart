import '../util.dart';

class Robot {
  static int areaHeight = 103;
  static int areaWidth = 101;

  Vector velocity;
  Vector position;
  Robot(this.velocity, this.position);

  void move(int seconds) {
    position = Vector(
      (position.row + (velocity.row * seconds)) % areaHeight,
      (position.col + (velocity.col * seconds)) % areaWidth
    );
  }
}

Vector rcVectorFromXYStringPair(List<String> pair) =>
  Vector(int.parse(pair[1]), int.parse(pair[0]))
;

List<Robot> getData([
  String inputFileName = "input.txt",
  int? areaHeight, 
  int? areaWidth
]) {
  if (areaHeight != null) Robot.areaHeight = areaHeight;
  if (areaWidth != null) Robot.areaWidth = areaWidth;
  return readInput(inputFileName).map(
    (String line) => Robot(
      rcVectorFromXYStringPair(
        RegExp(r"v=-?\d*,-?\d*").stringMatch(line)!.substring(2).split(',')
      ),
      rcVectorFromXYStringPair(
        RegExp(r"p=\d*,\d*").stringMatch(line)!.substring(2).split(',')
      )
    )
  ).toList();
}

int safetyFactor(Iterable<Robot> robots) {
  List<int> quadrants = List.filled(4, 0, growable: false);
  int middleRow = Robot.areaHeight ~/ 2;
  int middleCol = Robot.areaWidth ~/ 2;
  for (Robot robot in robots) {
    if (robot.position.row < middleRow) {
      if (robot.position.col < middleCol) quadrants[0]++;
      else if (robot.position.col > middleCol) quadrants[1]++;
    }
    else if (robot.position.row > middleRow) {
      if (robot.position.col < middleCol) quadrants[2]++;
      else if (robot.position.col > middleCol) quadrants[3]++;
    }
  }
  return quadrants.reduce((a,b)=>a*b);
}

void main() {
  List<Robot> robots = getData();
  for (Robot robot in robots) robot.move(100);
  print(safetyFactor(robots));
}