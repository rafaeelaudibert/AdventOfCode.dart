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

  List<List<int>> asteroids = [
    for (var i in range(0, SIZE))
      for (var j in range(0, SIZE)) if (data[i][j] == '#') [i, j]
  ];

  return asteroids;
}

// Hard to believe it works with floating point
List<double> can_see(int x, int y, List<List<int>> asteroids) =>
    Set<double>.from([
      for (var asteroid in asteroids)
        if (asteroid[0] != x || asteroid[1] != y)
          atan2(y - asteroid[1], x - asteroid[0])
    ]).toList();

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

day_10_part_1() =>
    get_how_many().map((asteroid) => asteroid['angles'].length).reduce(max);

// Can't figure that out
day_10_part_2() => throw UnimplementedError();
