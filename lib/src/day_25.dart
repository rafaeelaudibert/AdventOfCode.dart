/// Code for the solution of 2019 AoC, day 25.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/25)
import 'package:advent_of_code/helpers.dart';
import 'package:trotter/trotter.dart';
import 'computer.dart';
import 'dart:io';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 25, part: 1).split(',').map(int.parse).toList();

// Brute force it, manually having explored the map
// to find the actual items and the paths
day_25_part_1() {
  var data = _processInput();
  var computer = Computer(code: data);

  List<String> all_items = [
    "space law space brochure",
    "manifold",
    "weather machine",
    "prime number",
    "polygon",
    "astrolabe",
    "mouse",
    "hologram"
  ];
  var subs = Subsets(all_items);

  String commands =
      "north\ntake polygon\nnorth\ntake astrolabe\nsouth\nsouth\nwest\ntake hologram\nnorth\nnorth\ntake prime number\nsouth\neast\ntake space law space brochure\nwest\nsouth\neast\nsouth\neast\ntake weather machine\nwest\nsouth\ntake manifold\nwest\ntake mouse\nnorth\nnorth\n";
  computer.addAsciiInput(commands);

  int commands_quantity = commands.split('').where((str) => str == '\n').length;
  String old_output = null;
  for (int i = 0; i < commands_quantity;) {
    var output = computer.step_until_ascii_output();

    if (output == '?' && old_output == 'd') i++;

    old_output = output;
  }

  // Add the inputs for all the combinations
  for (var sub in subs()) {
    if (sub.length == 0) continue;
    String drop_all = 'drop ' + all_items.join('\ndrop ') + '\n';
    computer.addAsciiInput(drop_all);

    String take_some = 'take ' + sub.join('\ntake ') + '\n';
    computer.addAsciiInput(take_some);

    computer.addAsciiInput('east\n');
  }

  // Print the code
  String str_output = '';
  while (!computer.halted) {
    var output = computer.step_until_ascii_output();
    if (int.tryParse(output) != null) str_output += output;
  }

  return int.parse(str_output);
}

day_25_part_2() => _processInput();
