/// Code for the solution of 2019 AoC, day 18.
/// This code is a huge copy from [QuiteQuiet code](https://github.com/QuiteQuiet/AdventOfCode)
/// Thanks for sharing it.
/// There were made some improvement on the code, making it more Dart-like
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/18)
import 'package:advent_of_code/helpers.dart';
import 'dart:collection';
import 'package:collection/collection.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() =>
    readFromFiles(day: 18, part: 1).split('\n').toList();

class Grid<T> {
  List<T> cells;
  int w, h;

  Grid(this.w, this.h);
  Grid.initiate(this.w, this.h, T e) {
    this.cells = List.filled(this.h * this.w, e, growable: true);
  }

  T at(int x, int y) => this.cells[y * w + x];
  T at_point(Point p) => this.at(p.x, p.y);
  void put(int x, int y, T e) => this.cells[y * w + x] = e;
  void add(T e) => this.cells.add(e);

  int count(T e) => cells.where((el) => el == e).length;

  String toString() {
    List<String> s = [];
    for (int i = 0; i < h; i++) {
      for (int j = 0; j < w; j++) s.add(at(j, i).toString());
      s.add('\n');
    }
    return s.join('');
  }
}

List bfs(Point start, Point end, Grid<String> maze) {
  Queue steps = Queue.from([
    [
      start,
      [0]
    ]
  ]);
  Set<Point> visited = Set();

  while (steps.isNotEmpty) {
    List things = steps.removeFirst();
    Point cur = things[0];
    List blocks = List.from(things[1]);

    if (maze.at(cur.x, cur.y) != ".") blocks.add(maze.at_point(cur));
    blocks[0]++;

    // If reached the destination, return steps taken
    if (cur == end) return blocks;

    visited.add(cur);
    Point up = Point(cur.x - 1, cur.y),
        down = Point(cur.x + 1, cur.y),
        left = Point(cur.x, cur.y - 1),
        right = Point(cur.x, cur.y + 1);

    if (maze.at_point(up) != '#' && !visited.contains(up))
      steps.add([up, blocks]);

    if (maze.at_point(down) != '#' && !visited.contains(down))
      steps.add([down, blocks]);

    if (maze.at_point(left) != '#' && !visited.contains(left))
      steps.add([left, blocks]);

    if (maze.at_point(right) != '#' && !visited.contains(right))
      steps.add([right, blocks]);
  }

  throw Exception('Should never happen');
}

int getShortestPath(List<String> input, {bool ignoreDoors = false}) {
  Grid<String> maze = Grid.initiate(input[0].length, input.length, ' ');
  RegExp interest_chars = RegExp(r'[a-z@]');
  Map<String, Point> pointsOfInterest = {};

  // Generating maze
  for (int y = 0; y < input.length; y++) {
    for (int x = 0; x < input[y].length; x++) {
      maze.put(x, y, input[y][x]);

      if (interest_chars.hasMatch(input[y][x]))
        pointsOfInterest[input[y][x]] = Point(x, y);
    }
  }

  // Generate graph (on edges)
  Map<String, int> edges = {};
  for (var pair in generate_tuples(pointsOfInterest.keys.toList())) {
    List edge = bfs(pointsOfInterest[pair[0]], pointsOfInterest[pair[1]], maze);
    int weight = edge.removeAt(0);
    if (edge.last == '@') edge = edge.reversed.toList();
    edges[edge.join()] = weight - 1;
  }

  // Traverse the graph
  int keysToFind = pointsOfInterest.keys.length;
  Set<String> explored = Set();
  PriorityQueue search = PriorityQueue<List>((l1, l2) => l1.last - l2.last);
  List shortest;

  search.add([
    '@',
    ['@'],
    0
  ]);
  while (search.isNotEmpty) {
    List things = search.removeFirst();
    String curPos = things[0];
    String repr = '$curPos: ${(things[1]..sort()).join()}';

    // Continue if already explored
    if (explored.contains(repr)) continue;

    // Add it to the explored
    explored.add(repr);

    // Initialize the shortest
    if (things[1].length == keysToFind) shortest ??= things;

    // Every edge from or to the curPos
    for (String edge in edges.keys
        .where((el) => el[0] == curPos || el[el.length - 1] == curPos)) {
      bool canReachEnd = true;
      String workingEdge = edge;
      List<String> keys = List.from(things[1]);

      // Always go from curPos to dest
      if (workingEdge[0] != curPos)
        workingEdge = edge.split('').reversed.join();

      String dest = workingEdge[workingEdge.length - 1];
      canReachEnd = !keys.contains(dest);
      for (int i = 1; i < edge.length && canReachEnd; i++) {
        if (interest_chars.hasMatch(workingEdge[i]) &&
            !keys.contains(workingEdge[i])) {
          keys.add(workingEdge[i]);
        } else if (!keys.contains(workingEdge[i].toLowerCase())) {
          canReachEnd = ignoreDoors; // Only pass if can ignore it
        }
      }

      // Will search for the other key
      if (canReachEnd) {
        search.add([dest, keys, things[2] + edges[edge]]);
      }
    }
  }

  return shortest[2];
}

day_18_part_1() => getShortestPath(_processInput());

day_18_part_2() {
  var data = _processInput();

  // Too gambiarristic (but generic) way to replace the central area
  int robot_position_y =
          data.indexOf(data.firstWhere((row) => row.split('').contains('@'))),
      robot_position_x = data[robot_position_y].indexOf('@');
  data[robot_position_y - 1] = (data[robot_position_y - 1].split('')
        ..setRange(robot_position_x - 1, robot_position_x + 2, ['@', '#', '@']))
      .join();
  data[robot_position_y] = (data[robot_position_y].split('')
        ..fillRange(robot_position_x - 1, robot_position_x + 2, '#'))
      .join();
  data[robot_position_y + 1] = (data[robot_position_y + 1].split('')
        ..setRange(robot_position_x - 1, robot_position_x + 2, ['@', '#', '@']))
      .join();

  // "Create" the 4 differents mazes
  List<String> maze1 = [], maze2 = [], maze3 = [], maze4 = [];
  for (int i in range(0, data.length ~/ 2 + 1)) {
    maze1.add(data[i].substring(0, data.length ~/ 2 + 1));
    maze3.add(data[i].substring(data.length ~/ 2, data.length));
  }

  for (int i in range(data.length ~/ 2, data.length)) {
    maze2.add(data[i].substring(0, data.length ~/ 2 + 1));
    maze4.add(data[i].substring(data.length ~/ 2, data.length));
  }

  int shortestPathMult = getShortestPath(maze1, ignoreDoors: true) +
      getShortestPath(maze2, ignoreDoors: true) +
      getShortestPath(maze3, ignoreDoors: true) +
      getShortestPath(maze4, ignoreDoors: true);

  return shortestPathMult;
}
