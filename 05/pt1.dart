import 'dart:io';

List<String> getData([String inputFileName = "input.txt"]) {
  return File([Directory.current.path, inputFileName].join(Platform.pathSeparator)).readAsLinesSync();
}