/// Code for the solution of 2019 AoC, day 3.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/3)
import 'package:advent_of_code/helpers.dart';
import 'dart:math';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() => readFromFiles(day: 3, part: 1).split('\n');

// Global direction maps
const Map<String, int> dirX = {'U': 0, 'D': 0, 'R': 1, 'L': -1};
const Map<String, int> dirY = {'U': 1, 'D': -1, 'R': 0, 'L': 0};

// Given a list of rays, compute all the points on it
Set<Point> getPointsSet(List<String> rays) {
  Set<Point> pointsSet = Set();
  Point currentPoint = Point(0, 0);

  for (var ray in rays) {
    var direction = ray[0];
    var quantity = ray.substring(1).toInt();

    for (var _ in range(0, quantity)) {
      currentPoint = Point(
          currentPoint.x + dirX[direction], currentPoint.y + dirY[direction]);
      pointsSet.add(currentPoint);
    }
  }

  return pointsSet;
}

// Compute the distance until a point in the full ray given the list of all the rays
int distUntil(List<String> rays, Point p) {
  Point currentPoint = Point(0, 0);
  int counter = 1;

  for (var ray in rays) {
    var direction = ray[0];
    var quantity = ray.substring(1).toInt();

    for (var i = 0; i < quantity; i++, counter++) {
      currentPoint = Point(
          currentPoint.x + dirX[direction], currentPoint.y + dirY[direction]);
      if (p == currentPoint) break;
    }
  }

  return counter;
}

int day_3_part_1() {
  var data = _processInput();
  var ray1 = data[0].split(',');
  var ray2 = data[1].split(',');

  var set1 = getPointsSet(ray1);
  var set2 = getPointsSet(ray2);

  Point origin = Point(0, 0);
  return set1.intersection(set2).map((p) => p.dist(origin)).reduce(min);
}

int day_3_part_2() {
  var data = _processInput();
  var ray1 = data[0].split(',');
  var ray2 = data[1].split(',');

  var set1 = getPointsSet(ray1);
  var set2 = getPointsSet(ray2);

  return set1
      .intersection(set2)
      .map((p) => distUntil(ray1, p) + distUntil(ray2, p))
      .reduce(min);
}
