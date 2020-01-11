/// Code for the solution of 2019 AoC, day 15.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/15)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';
import 'dart:collection';
import 'dart:math';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 15, part: 1).split(',').map(int.parse).toList();

const String AIR = ' ', WALL = '#', OXYGEN = '@';
const int NORTH = 1, SOUTH = 2, WEST = 3, EAST = 4;

Map<String, String> map = {'0,0': AIR};
var data = _processInput();
var computer = Computer(code: data);

exploreMapDFS(int x, int y, int dir_came_from) {
  // Go to NORTH
  if (dir_came_from != NORTH) {
    var output = (computer..addInput(NORTH)).step_until_output();

    if (output == 0) {
      map['${x},${y + 1}'] = WALL;
    } else if (output == 1) {
      map['${x},${y + 1}'] = AIR;
      exploreMapDFS(x, y + 1, SOUTH); // Came from South
    } else if (output == 2) {
      map['${x},${y + 1}'] = OXYGEN;
      exploreMapDFS(x, y + 1, SOUTH); // Came from South
    }
  }

  // Go to SOUTH
  if (dir_came_from != SOUTH) {
    var output = (computer..addInput(SOUTH)).step_until_output();

    if (output == 0) {
      map['${x},${y - 1}'] = WALL;
    } else if (output == 1) {
      map['${x},${y - 1}'] = AIR;
      exploreMapDFS(x, y - 1, NORTH);
    } else if (output == 2) {
      map['${x},${y - 1}'] = OXYGEN;
      exploreMapDFS(x, y - 1, NORTH);
    }
  }

  // Go to WEST
  if (dir_came_from != WEST) {
    var output = (computer..addInput(WEST)).step_until_output();

    if (output == 0) {
      map['${x - 1},${y}'] = WALL;
    } else if (output == 1) {
      map['${x - 1},${y}'] = AIR;
      exploreMapDFS(x - 1, y, EAST);
    } else if (output == 2) {
      map['${x - 1},${y}'] = OXYGEN;
      exploreMapDFS(x - 1, y, EAST);
    }
  }

  // Go to EAST
  if (dir_came_from != EAST) {
    var output = (computer..addInput(EAST)).step_until_output();

    if (output == 0) {
      map['${x + 1},${y}'] = WALL;
    } else if (output == 1) {
      map['${x + 1},${y}'] = AIR;
      exploreMapDFS(x + 1, y, WEST);
    } else if (output == 2) {
      map['${x + 1},${y}'] = OXYGEN;
      exploreMapDFS(x + 1, y, WEST);
    }
  }

  // Go back from where it came
  computer
    ..addInput(dir_came_from)
    ..step_until_output();

  return;
}

// Helper to create the map searching for both initial sides
createMap() {
  exploreMapDFS(0, 0, NORTH);
  exploreMapDFS(0, 0, SOUTH);
}

day_15_part_1() {
  createMap(); // Remember to create the map initially

  // Make flood-fill to find the distance for the oxygen tank
  Queue<String> floodFill = Queue.from(["0,0"]);
  Queue<int> floodFillDepth = Queue.from([1]);
  List<String> visited = [];
  while (floodFill.isNotEmpty) {
    var floodTo = floodFill.removeFirst();
    var floodDepth = floodFillDepth.removeFirst();
    visited.add(floodTo);

    var x = floodTo.split(',')[0].toInt();
    var y = floodTo.split(',')[1].toInt();

    if (map[floodTo] == OXYGEN) {
      return floodDepth;
    } else if (map[floodTo] == WALL) {
      continue;
    } else {
      // Air block, fill for all the sides not yet visited
      var nextFlood = [
        "${x + 1},${y}",
        "${x - 1},${y}",
        "${x},${y + 1}",
        "${x},${y - 1}"
      ].where((str) => !visited.contains(str));

      floodFill.addAll(nextFlood);
      floodFillDepth.addAll(List.filled(nextFlood.length, floodDepth + 1));
    }
  }

  return -1;
}

day_15_part_2() {
  createMap(); // Remember to create the map initially

  // Make flood-fill to find the distance from the oxygen tank,
  // that we need to find in the map first,
  // to the furthest place in the map
  String oxygen = map.keys.firstWhere((key) => map[key] == OXYGEN);
  Queue<String> floodFill = Queue.from([oxygen]);
  Queue<int> floodFillDepth = Queue.from([0]);
  List<String> visited = [];
  int maximum_depth = 1;
  while (floodFill.isNotEmpty) {
    var floodTo = floodFill.removeFirst();
    var floodDepth = floodFillDepth.removeFirst();

    visited.add(floodTo); // Mark visited
    maximum_depth = max(maximum_depth, floodDepth); // Increase total depth

    var x = floodTo.split(',')[0].toInt();
    var y = floodTo.split(',')[1].toInt();

    if (map[floodTo] == WALL) {
      continue;
    } else {
      // Air or oxygen block, fill for all the sides not yet visited
      var nextFlood = [
        "${x + 1},${y}",
        "${x - 1},${y}",
        "${x},${y + 1}",
        "${x},${y - 1}"
      ].where((str) => !visited.contains(str));

      floodFill.addAll(nextFlood);
      floodFillDepth.addAll(List.filled(nextFlood.length, floodDepth + 1));
    }
  }

  return maximum_depth;
}
