import 'dart:io';

Map<Stone, EvolutionPath> cache = {};

class EvolutionPath {
  List<int> lineLengths;
  List<Stone> latestLine;
  EvolutionPath(this.latestLine): lineLengths = [latestLine.length];

  void evolveTo(int iterations) {
    // we only need to do anything if the path hasn't already covered [iterations]
    if (lineLengths.length - 1 < iterations) {
      int childIterations = iterations;
      // our base case, if we have only one stone we evolve it and iterate one less time
      if (latestLine.length == 1) {
        latestLine = latestLine[0].evolve();
        lineLengths.add(latestLine.length);
        childIterations -= 1;
      }
      List<EvolutionPath> stonePaths = [];
      // evolve each stone in the line if we don't know it already
      for (Stone stone in latestLine) {
        if (cache.containsKey(stone)) {
          EvolutionPath currentPath = cache[stone]!;
          currentPath.evolveTo(childIterations);
          stonePaths.add(currentPath);
        }
        else {
          EvolutionPath currentPath = EvolutionPath([stone]);
          currentPath.evolveTo(childIterations);
          if (cache.containsKey(stone)) {
            currentPath = cache[stone]!;
          }
          cache[stone] = currentPath;
          stonePaths.add(currentPath);
        }
      }
      // update our understanding of this path based on its children
      for (int i = lineLengths.length; i < iterations + 1; i++) {
        lineLengths.add(
          stonePaths.map((path) => path.lineLengths[i + childIterations - iterations]).reduce((a,b)=>a+b)
        );
      }
      latestLine = stonePaths.map((path) => path.latestLine).reduce((a,b)=>a+b);
    }
  }
}

class Stone {
  int? intValue;
  String? strValue;

  Stone.fromInt(this.intValue);
  Stone.fromStr(this.strValue) {
    if (strValue!.startsWith('0')) {
      int nonZeroIndex = strValue!.indexOf(RegExp(r'[^0]'));
      strValue = strValue!.substring(nonZeroIndex == -1 ? strValue!.length - 1 : nonZeroIndex);
    }
  }

  List<Stone> evolve() =>
    (toInt() == 0) ? [
      Stone.fromInt(1)
    ]: 
    (toString().length % 2 == 0) ? [
      Stone.fromStr(toString().substring(0, toString().length ~/ 2)),
      Stone.fromStr(toString().substring(toString().length ~/ 2))  
    ]:
    [
      Stone.fromInt(toInt() * 2024)
    ]
  ;

  @override String toString() => 
    strValue ??
    (){
      strValue = intValue!.toString();
      return strValue!;
    }()
  ;
  int toInt() =>
    intValue ??
    (){
      intValue = int.parse(strValue!);
      return intValue!;
    }()
  ;
  @override int get hashCode => toInt();
}

List<Stone> getData([String inputFileName = "input.txt"]) => 
  (
    File(Directory.current.path + Platform.pathSeparator + inputFileName)
      .readAsStringSync()
      .trimRight()
      .split(' ')
      .map((value) => Stone.fromStr(value))
      .toList()
  )
;

void main() {
  print((EvolutionPath(getData())..evolveTo(25)).lineLengths.last);
}