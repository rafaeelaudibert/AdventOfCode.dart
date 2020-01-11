/// Code for the solution of 2019 AoC, day 6.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/6)
import 'package:advent_of_code/helpers.dart';
import 'dart:collection';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() => readFromFiles(day: 6, part: 1)
    .split('\n')
    .map((String str) => str.substring(0, str.length - 1))
    .toList();

var graph = HashMap<String, List<String>>();

void createGraph() {
  _processInput().map((orbit) => orbit.split(')')).forEach((orbit) {
    graph.putIfAbsent(orbit[0], () => List<String>());
    graph.putIfAbsent(orbit[1], () => List<String>());

    graph[orbit[0]].add(orbit[1]);
  });
}

int exploreGraph(String planet, int depth) {
  return graph[planet].fold(
      depth, (acc, next_planet) => acc + exploreGraph(next_planet, depth + 1));
}

String findOrbiting(String search) =>
    graph.keys.firstWhere((entry) => graph[entry].contains(search),
      orElse: () => 'COM_PARENT_THAT_DOESNT_EXIST');

day_6_part_1() {
  createGraph();

  return exploreGraph('COM', 0);
}

day_6_part_2() {
  createGraph();

  // Find who you are orbiting
  String you_orbiting = findOrbiting('YOU');

  // Find who SAN is orbiting
  String san_orbiting = findOrbiting('SAN');

  // Create a flag list for the DFS
  List already_visited = [you_orbiting];

  // Add to the starting list every planet orbiting [you_orbiting] and the planet it is orbiting
  var to_look_for = graph[you_orbiting].map((planet) => [planet, 1]).toList()
    ..add([findOrbiting(you_orbiting), 1]);

  // Find it
  while (to_look_for.length > 0) {
    String curr = to_look_for[0][0];
    int depth = to_look_for[0][1];
    already_visited.add(curr); // Add to already visited

    // If found, return it
    if (curr == san_orbiting) return depth;

    // Removes first object from the queue
    to_look_for.removeAt(0);

    // Add the others to the end of the queue, if not visited yet
    String curr_orbiting = findOrbiting(curr);
    if (!already_visited.contains(curr_orbiting) && curr_orbiting != 'COM')
      to_look_for.add([curr_orbiting, depth + 1]);

    to_look_for.addAll(graph[curr]
        .where((planet) => !already_visited.contains(planet) && planet != 'COM')
        .map((planet) => [planet, depth + 1]));
  }

  return 'oops';
}
