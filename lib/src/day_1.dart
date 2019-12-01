/// Code for the solution of 2019 AoC, day 1.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/1)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() => readFromFiles(day: 1, part: 1)
    .split('\n')
    .map((i) => int.parse(i))
    .toList();

int totalFuel_part_1 = 0;
int totalFuel_part_2 = 0;

int addFuel(int mass) {
  int fuel = (mass / 3).floor() - 2;
  return fuel > 0 ? fuel + addFuel(fuel) : 0;
}

day_1_part_1() =>
    _processInput().fold(0, (acc, mass) => acc + ((mass / 3).floor() - 2));

day_1_part_2() => _processInput().fold(0, (acc, mass) => acc + addFuel(mass));
