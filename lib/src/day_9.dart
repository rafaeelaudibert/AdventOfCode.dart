/// Code for the solution of 2019 AoC, day 9.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/9)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 9, part: 1).split(',').map(int.parse).toList();

day_9_part_1({input: 1}) {
  var data = _processInput();
  var computer = Computer(code: data)..addInput(input);

  int output = 0;
  while (!computer.halted) {
    output = computer.step_until_output();
    print(output); // To see errors
  }

  return output;
}

day_9_part_2() => day_9_part_1(input: 2);
