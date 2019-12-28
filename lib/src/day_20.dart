/// Code for the solution of 2019 AoC, day 20.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/20)
import 'package:advent_of_code/helpers.dart';
import 'package:collection/collection.dart';
import 'dart:collection';
import 'package:tuple/tuple.dart';

// FOR SOME WEIRD REASON, NEED TO REMOVE 1 LETTER FROM THE END,
// PROBABLY BECAUSE OF WINDOWS /n/r, SO WE NEED TO ADD MANUALLY AN EXTRA SPACE
// AT THE END OF THE FILE, IN THE LAST LINE
/// Read the raw [String] content from file and convert it to
/// [List<List<String>>].
List<List<String>> _processInput() => readFromFiles(day: 20, part: 1)
    .split('\n')
    .map((str) => str.substring(0, str.length - 1).split(''))
    .toList();

final RegExp portal_regex = new RegExp('[A-Z]');

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

day_20_part_2() => _processInput();
