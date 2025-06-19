import '../util.dart';

class Maze {
  List<List<bool>> mazeMap;
  Vector start;
  Vector end;
  Maze(this.mazeMap, this.start, this.end);
}

class State {
  Vector position;
  Vector direction;
  int score;
  State(this.position, this.direction, this.score);
}

Maze getData([String inputFileName = "input.txt"]) {
  List<String> input = readInput(inputFileName);
  
  List<List<bool>> map = [];
  Vector start = Vector(-1, -1);
  Vector end = Vector(-1, -1);

  for (int row = 0; row < input.length; row++) {
    map.add([]);
    for (int col = 0; col < input[row].length; col++) {
      map[row].add(input[row][col] != '#');
      if (input[row][col] == 'S') start = Vector(row, col);
      if (input[row][col] == 'E') end = Vector(row, col);
    }
  }

  return Maze(map, start, end);
}

bool isEmpty(Vector position, List<List<bool>> map) =>
  map[position.row][position.col]
;

List<State> findCheapestPath(Maze maze) {
  PriorityQueue<List<State>> paths = PriorityQueue.from(
    [[State(maze.start, Vector(0, 1), 0)]], 
    (a, b) => (a.last.score < b.last.score ? -1 : a.last.score > b.last.score ? 1 : 0)
  );
  while(true) {
    List<State> current = paths.remove();
    if (current.last.position == maze.end) return current;

    for (Vector direction in orthogonals.where((turn) => 
      ( // directions that are either forward or quarter turns
        (turn.row == current.last.direction.row) ==
        (turn.col == current.last.direction.col)
      ) && isEmpty(current.last.position + turn, maze.mazeMap)
    )) {
      // follow direction to the next fork
      int steps = 1;
      while ( // current position is empty and both perpendiculars are walls
        ((Vector position) => 
          isEmpty(position + direction, maze.mazeMap) &&
          orthogonals.where((turn) =>
            (turn.row == current.last.direction.row) &&
            (turn.col == current.last.direction.col)
          ).map(
            (side) => !isEmpty(position + side, maze.mazeMap)
          ).reduce((a,b)=>a&&b)
        )(current.last.position + (direction * steps))
      ) steps++;
      List<State> newPath = current + [State(
        current.last.position + (direction * steps),
        direction,
        current.last.score + (direction != current.last.direction ? 1000 : 0) + steps
      )];
      paths.insert(newPath);
    }
  }
}

void main() {
  print(findCheapestPath(getData()).last.score);
}