/// Code for the solution of 2019 AoC, day 21.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/21)
import 'package:advent_of_code/helpers.dart';
import 'dart:io';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 21, part: 1).split(',').map(int.parse).toList();

String get get_input => stdin.readLineSync();

int run(String commands) {
  var data = _processInput();
  var computer = Computer(code: data)..addAsciiInput(commands);

  while (!computer.halted) {
    var output = computer.step_until_output();

    if ((output ?? 0) > 300) {
      print(commands);
      return output;
    }
  }

  throw FallThroughError();
}

day_21_part_1() => run('NOT A T\nNOT C J\nOR T J\nAND D J\nWALK\n');

day_21_part_2() =>
    run('NOT H T\nOR C T\nAND B T\nAND A T\nNOT T J\nAND D J\nRUN\n');

day_21_part_1_try() {
  var data = _processInput();

  final available_instr = ['NOT', 'AND', 'OR'];
  final available_x = ['A', 'B', 'C', 'D', 'E', 'T', 'J'];
  final available_y = ['T', 'J'];
  final possible_quantities = range(1, 16).toList();

  // Try for 100000 times (i'm sorry)
  for (int iter in range(0, 100000)) {
    print(iter);
    var commands = range(1, (possible_quantities..shuffle()).first + 1)
            .map((_) =>
                '${(available_instr..shuffle()).first} ${(available_x..shuffle()).first} ${(available_y..shuffle()).first}')
            .join('\n') +
        '\nWALK\n';

    var computer = Computer(code: data)..addAsciiInput(commands);
    while (!computer.halted) {
      var output = computer.step_until_output();

      if ((output ?? 0) > 300) {
        print(commands);
        return output;
      }
    }
  }

  throw FallThroughError();
}
