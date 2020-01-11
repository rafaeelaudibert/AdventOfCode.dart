/// Code for the solution of 2019 AoC, day 5.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/5)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 5, part: 1).split(',').map(int.parse).toList();

int day_5_part_1({int input = 1}) => day_5_part_2(input: input);

int day_5_part_2({int input = 5}) {
  Computer intMachine = Computer(code: _processInput())..addInput(input);
  int last_output = null;

  while (!intMachine.halted) last_output = intMachine.step_until_output();

  return last_output;
}
