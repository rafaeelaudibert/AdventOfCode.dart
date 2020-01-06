/// Code for the solution of 2019 AoC, day 20.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/20)
import 'package:advent_of_code/helpers.dart';
import 'package:collection/collection.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';
import 'dart:math';

// Regex to find uppercase letters
final RegExp portal_regex = new RegExp('[A-Z]');

// FOR SOME WEIRD REASON, NEED TO REMOVE 1 LETTER FROM THE END,
// PROBABLY BECAUSE OF WINDOWS /n/r, SO WE NEED TO ADD MANUALLY AN EXTRA SPACE
// AT THE END OF THE FILE, IN THE LAST LINE
/// Read the raw [String] content from file and convert it to
/// [List<List<String>>].
List<List<String>> _processInput() => readFromFiles(day: 20, part: 1)
    .split('\n')
    .map((str) => str.substring(0, str.length - 1).split(''))
    .toList();

int djikstra(Map<String, Map<String, int>> graph, String start, String end) {
  PriorityQueue<Tuple2<String, int>> pq =
      PriorityQueue((p1, p2) => p1.item2 - p2.item2);
  pq.add(Tuple2(start, 0)); // Start from it with cost 0

  // Create a copy to represent distances
  Map<String, Map<String, int>> distances =
      Map<String, Map<String, int>>.from(graph).map((portal, list_portals) =>
          MapEntry(portal,
              list_portals.map((str, dist) => MapEntry(str, 1000000000))));
  Set<String> visited = Set(); // Mark the already visited portals
  while (pq.isNotEmpty) {
    var next = pq.removeFirst();
    var element = next.item1;
    var cost = next.item2;
    var neighbors = graph[element].keys;

    // Avoid loops
    if (visited.contains(element)) continue;
    visited.add(element);

    // Return earlier
    if (element == end) return cost;

    for (var neighbor in neighbors) {
      var neighbor_cost = cost + graph[element][neighbor];
      if (neighbor_cost < distances[element][neighbor]) {
        distances[element][neighbor] = neighbor_cost;
        pq.add(Tuple2(neighbor, neighbor_cost));
      }
    }
  }

  throw FallThroughError();
}

day_20_part_1() {
  var maze = _processInput();
  var maze_y = maze.length, maze_x = maze[0].length;

  Map<Point, String> portals = {};
  for (int y in range(0, maze_y)) {
    for (int x in range(0, maze_x)) {
      // If it is at a point
      if (maze[y][x] == '.') {
        // Look for portals around it
        if (portal_regex.hasMatch(maze[y - 1][x])) {
          String portal = maze[y - 2][x] + maze[y - 1][x];
          portals[Point(x, y - 1)] = portal;
        } else if (portal_regex.hasMatch(maze[y + 1][x])) {
          String portal = maze[y + 1][x] + maze[y + 2][x];
          portals[Point(x, y + 1)] = portal;
        } else if (portal_regex.hasMatch(maze[y][x - 1])) {
          String portal = maze[y][x - 2] + maze[y][x - 1];
          portals[Point(x - 1, y)] = portal;
        } else if (portal_regex.hasMatch(maze[y][x + 1])) {
          String portal = maze[y][x + 1] + maze[y][x + 2];
          portals[Point(x + 1, y)] = portal;
        }
      }
    }
  }

  // Create a graph with various BFS, from each portal
  Map<String, Map<String, int>> graph =
      portals.map((point, str) => MapEntry(str, Map()));
  for (var portal in portals.values.toSet().toList()) {
    List<Point> portal_positions = portals.entries
        .where((point_string) => point_string.value == portal)
        .map((entry) => entry.key)
        .toList();

    for (var portal_position in portal_positions) {
      Queue<Tuple2<Point, int>> to_search = Queue();
      if (maze[portal_position.y + 1][portal_position.x] == '.') {
        to_search.add(Tuple2(
            Point(
              portal_position.x,
              portal_position.y + 1,
            ),
            1));
      }

      if (maze[portal_position.y - 1][portal_position.x] == '.') {
        to_search
            .add(Tuple2(Point(portal_position.x, portal_position.y - 1), 1));
      }

      if (maze[portal_position.y][portal_position.x + 1] == '.') {
        to_search
            .add(Tuple2(Point(portal_position.x + 1, portal_position.y), 1));
      }

      if (maze[portal_position.y][portal_position.x - 1] == '.') {
        to_search
            .add(Tuple2(Point(portal_position.x - 1, portal_position.y), 1));
      }

      // BFS for each portal
      List<Point> visited = [];
      while (to_search.isNotEmpty) {
        var next = to_search.removeFirst();
        var position = next.item1;
        var distance = next.item2;

        // Avoid loops
        if (visited.contains(position)) continue;
        visited.add(position);

        // Find nodes connected
        if (portals[Point(position.x, position.y + 1)] != null) {
          graph[portal][portals[Point(position.x, position.y + 1)]] = distance;
        }
        if (portals[Point(position.x, position.y - 1)] != null) {
          graph[portal][portals[Point(position.x, position.y - 1)]] = distance;
        }
        if (portals[Point(position.x + 1, position.y)] != null) {
          graph[portal][portals[Point(position.x + 1, position.y)]] = distance;
        }
        if (portals[Point(position.x - 1, position.y)] != null) {
          graph[portal][portals[Point(position.x - 1, position.y)]] = distance;
        }

        // Find edges to explore
        if (maze[position.y + 1][position.x] == '.') {
          to_search
              .add(Tuple2(Point(position.x, position.y + 1), distance + 1));
        }
        if (maze[position.y - 1][position.x] == '.') {
          to_search
              .add(Tuple2(Point(position.x, position.y - 1), distance + 1));
        }
        if (maze[position.y][position.x + 1] == '.') {
          to_search
              .add(Tuple2(Point(position.x + 1, position.y), distance + 1));
        }
        if (maze[position.y][position.x - 1] == '.') {
          to_search
              .add(Tuple2(Point(position.x - 1, position.y), distance + 1));
        }
      }
    }
  }

  // Remove self edges
  graph = graph.map((portal, list_edges) => MapEntry(portal,
      list_edges..removeWhere((other_portal, _d) => other_portal == portal)));

  // Run djikstra on the graph
  return djikstra(graph, 'AA', 'ZZ') - 1;
}

// Translated from [/u/bla2](https://www.reddit.com/user/bla2/) Python3 code, available
// [here](https://topaz.github.io/paste/#XQAAAQCDBwAAAAAAAAAzHIoib6pENkSmUIKIED8dy140D1lKWSU7djMRT1Zy3HFl2YwVCAZ0dUJT0cGTOmOnnqAN8eNRq3NaF3RBV6e9snmWMunIsY+MR0q8wqlCYP1OthBSjU8xj67Ncnl0SahUjgleue17877DcW1RVZMXmLYihJgRdrZxS3eRmLQu/lm6ZxZldPGzo0Ncj7q1wfE9yl/eamOLJsneKAmBxdCejQBgANCSF7+nkkk34PyDSV7pOT8ba5zOXQmRgs8UR2TrzBKhtW9BSih9zpyUWB4CI7cvscgc6mdK6dXYxZtrIpSw1HXUmgR+X9yCXVzSdjKQ0mxDTkd/Hn/c/IneF9eka6CUZthfAG+TEU+Ml2SimiS7IC6JrOZVA2PWgQKYW7tS8VtFRkdhQbeiqsQwk7QocomEB0qMR55srb4GCYWHNLfMjcffgdbLQSV0V/FitHRAPsH/JVgMGhwLlr2AgK+kvSDBMbJgvPvPkbKmPJvbnuFIvtbaV0PLOvYpH74Sx3797LUPuvGYhr92zpW1HOXGXVLlqH9YyQlE1k6WZNTIX50R//YBGiYf+O7xR82sr3b/PqPpAB8EU+SGmAtAO4f9rrOtiayf+gEj9poa+HyaEgLn7BmiUzRzmoXJqk4Xf0OsVEC7bIWJJFgav3eZ88N5tZDr5EotW7SLEGDTzMa7z3CpyLOtCl2iV34BJ973+WnBxQlZHC5f6BIfkEfilt/O0RRAbDKtKOgcDVn4gczewuIN+VLH1IcdaaErqeJ0FuLOZ0DoUxiGqI62Ac9u8tyEnUJwexs+TmuzG+7qlUcDY+z9FBXfy0XNPDrwddIyq80YQuNiYkzhrlFZiRjY3mw4E/ZBzUPZ3irQ+rVGrb50LT72GCrWZeMFAM/0vDt6tw/Jm0g1oYJ/KItNdiMS76aAR4mZon1vtjJ7+WFCFeSm90sY6tuC8U959ljwQsobiQ8b3Zwbi+rEAwtrOJIgte8QwP4Cpnb+QCMm)
day_20_part_2() {
  var data = _processInput();
  var maze_y = data.length, maze_x = data[0].length;

  // Find portals
  Map<String, List<Tuple2<int, int>>> portals = {};
  for (var y in range(0, maze_y - 1)) {
    for (var x in range(0, maze_x - 1)) {
      if (!portal_regex.hasMatch(data[y][x])) continue;

      // Found match looking above
      if (portal_regex.hasMatch(data[y + 1][x])) {
        var c = data[y][x] + data[y + 1][x];
        portals.putIfAbsent(c, () => List());
        if (y > 0 && data[y - 1][x] == '.')
          portals[c].add(Tuple2(x, y - 1));
        else if (data[y + 2][x] == '.') portals[c].add(Tuple2(x, y + 2));
      }

      // Found match for the right
      if (portal_regex.hasMatch(data[y][x + 1])) {
        var c = data[y][x] + data[y][x + 1];
        portals.putIfAbsent(c, () => List());
        if (x > 0 && data[y][x - 1] == '.')
          portals[c].add(Tuple2(x - 1, y));
        else if (data[y][x + 2] == '.') portals[c].add(Tuple2(x + 2, y));
      }
    }
  }

  // Get src and dst positions
  var src = portals['AA'].first;
  var dst = portals['ZZ'].first;

  // Find path
  var q = Queue<Tuple3<Tuple2, int, int>>.from(
      [Tuple3(src, 0, 0)]); // pos, level, dist
  var seen = Set<Tuple3<int, int, int>>.from(
      [Tuple3(src.item1, src.item2, 0)]); // pos x, pos y, level
  while (q.isNotEmpty) {
    var first_item = q.removeFirst();
    var pos = first_item.item1;
    var level = first_item.item2;
    var dist = first_item.item3;

    // If reached 'ZZ' on level 0, return the distance
    if (pos == dst && level == 0) return dist;

    for (var d in [
      [-1, 0],
      [1, 0],
      [0, -1],
      [0, 1]
    ]) {
      var dx = d[0], dy = d[1];
      var nx = pos.item1 + dx, ny = pos.item2 + dy;
      var new_level = level;
      if (portal_regex.hasMatch(data[ny][nx])) {
        var is_outer =
            nx == 1 || ny == 1 || nx == maze_x - 2 || ny == maze_y - 2;
        if (is_outer)
          new_level -= 1;
        else
          new_level += 1;

        var c = (data[min(ny, ny + dy)][min(nx, nx + dx)] +
            data[max(ny, ny + dy)][max(nx, nx + dx)]);
        if (!['AA', 'ZZ'].contains(c) && new_level >= 0) {
          var looking_for_0 = pos == portals[c][0];
          nx = portals[c][looking_for_0 ? 1 : 0].item1;
          ny = portals[c][looking_for_0 ? 1 : 0].item2;
        }
      }

      // Avoid loop
      if (seen.contains(Tuple3(nx, ny, new_level))) continue;
      seen.add(Tuple3(nx, ny, new_level));

      // Add to search after
      if (data[ny][nx] == '.')
        q.add(Tuple3(Tuple2(nx, ny), new_level, dist + 1));
    }
  }
}
