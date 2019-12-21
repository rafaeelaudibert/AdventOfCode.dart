/// Code for the solution of 2019 AoC, day 10.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/10)
import 'package:advent_of_code/helpers.dart';
import 'dart:math';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() =>
    readFromFiles(day: 10, part: 1).split('\n').toList();

// Global size
const SIZE = 20;

List<List<int>> getAsteroids() {
  var data = _processInput();

  List<List<int>> asteroids = [];
  for (var i in range(0, SIZE)) {
    for (var j in range(0, SIZE)) {
      if (data[i][j] == '#') {
        asteroids.add([i, j]);
      }
    }
  }

  return asteroids;
}

List<double> can_see(int x, int y, List<List<int>> asteroids) {
  var angles = Set<double>();
  for (var asteroid in asteroids)
    if (asteroid[0] != x || asteroid[1] != y)
      angles.add(atan2(y - asteroid[1],
          x - asteroid[0])); // Hard to believe it works with floating point

  return angles.toList();
}

List<Map<String, List<double>>> get_how_many() {
  var asteroids = getAsteroids();

  return asteroids
      .map((List<int> asteroid) => ({
            'angles': can_see(asteroid[0], asteroid[1], asteroids),
            'x': [asteroid[0] * 1.0],
            'y': [asteroid[1] * 1.0]
          }))
      .toList();
}

day_10_part_1() => get_how_many()
    .map((asteroid) => asteroid['angles'].length)
    .toList()
    .reduce(max);

// Can't figure that out
day_10_part_2() => throw UnimplementedError();

// day_10_part_2() {
//   var data = _processInput();

//   List<List<int>> asteroids = [];
//   for (var i in range(0, SIZE)) {
//     for (var j in range(0, SIZE)) {
//       if (data[i][j] == '#') {
//         asteroids.add([i, j]);
//       }
//     }
//   }

//   var the_asteroid = get_how_many()
//       .firstWhere((info) => info['angles'].length == day_10_part_1());
//   var angles = the_asteroid['angles'];

//   Map<double, List<List<int>>> angles_list = {};
//   for (var i = 0; i < asteroids.length; i++) {
//     var asteroid = asteroids[i];
//     var angle = atan2(
//         the_asteroid['y'][0] - asteroid[1], the_asteroid['x'][0] - asteroid[0]);

//     angles_list.putIfAbsent(angle, () => []);
//     angles_list[angle].add(asteroid);
//   }
//   var angless = angles_list.keys.toList();
//   print(angless);
//   angless.sort();
//   print(angless);
//   print(angles_list[angless[0]]);

//   print(the_asteroid['x'][0]);
//   print(the_asteroid['y'][0]);

//   return 0;
// }
