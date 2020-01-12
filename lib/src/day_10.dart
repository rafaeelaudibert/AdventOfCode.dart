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
const SIZE = 21;

// Parse input and get all asteroids
List<Point> getAsteroids() {
  var data = _processInput();

  return [
    for (var i in range(0, SIZE))
      for (var j in range(0, SIZE)) if (data[i][j] == '#') Point(i, j)
  ];
}

// Hard to believe it works with floating point
Set<double> can_see(Point asteroid, List<Point> asteroids) => Set<double>.from([
      for (var other_asteroid in asteroids)
        if (other_asteroid.x != asteroid.x || other_asteroid.y != asteroid.y)
          atan2(asteroid.y - other_asteroid.y, asteroid.x - other_asteroid.x)
    ]);

Iterable<Set<double>> get_how_many() {
  var asteroids = getAsteroids();

  return asteroids.map((Point asteroid) => can_see(asteroid, asteroids));
}

day_10_part_1() => get_how_many()
    .fold(0, (int maximum, var asteroid) => max(maximum, asteroid.length));

day_10_part_1_different() =>
    get_how_many().map<int>((asteroid) => asteroid.length).reduce(max);

// Based on [julemand101](https://github.com/julemand101/) code available
// [here](https://github.com/julemand101/AdventOfCode2019/blob/master/lib/day10.dart)
day_10_part_2() {
  final asteroids = getAsteroids();

  final station = findStation(asteroids);
  asteroids.remove(station);

  var asteroidsDestroyed = 0;
  while (asteroids.isNotEmpty) {
    final angleToAsteroid = <double, Point>{};

    for (final asteroid in asteroids) {
      final angle = atan2(asteroid.y - station.y, asteroid.x - station.x);

      if (angleToAsteroid.containsKey(angle)) {
        if (asteroid.dist(station) < angleToAsteroid[angle].dist(station)) {
          angleToAsteroid[angle] = asteroid;
        }
      } else {
        angleToAsteroid[angle] = asteroid;
      }
    }

    final anglesOfAsteroidsToDestroy = angleToAsteroid.keys.toList()..sort();
    for (final degree in anglesOfAsteroidsToDestroy.reversed) {
      final asteroidToRemove = angleToAsteroid[degree];
      asteroids.remove(asteroidToRemove);

      if (++asteroidsDestroyed == 200) {
        return (asteroidToRemove.y * 100) + asteroidToRemove.x;
      }
    }
  }

  throw FallThroughError();
}

Point findStation(List<Point> asteroids) {
  var maximum_how_many = day_10_part_1();

  return asteroids.elementAt(get_how_many()
      .toList()
      .indexWhere((asteroids) => asteroids.length == maximum_how_many));
}
