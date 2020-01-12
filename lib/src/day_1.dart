/// Code for the solution of 2019 AoC, day 1.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/1)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [Iterable<int>].
Iterable<int> _processInput() =>
    readFromFiles(day: 1, part: 1).split('\n').map(int.parse);

int addFuel(int mass) {
  int fuel = (mass / 3).floor() - 2;
  return fuel > 0 ? fuel + addFuel(fuel) : 0;
}

day_1_part_1() =>
    _processInput().fold(0, (acc, mass) => acc + ((mass / 3).floor() - 2));

day_1_part_2() => _processInput().fold(0, (acc, mass) => acc + addFuel(mass));
