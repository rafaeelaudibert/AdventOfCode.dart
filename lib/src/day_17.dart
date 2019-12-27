/// Code for the solution of 2019 AoC, day 17.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/17)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';
import 'dart:io';
import 'dart:convert';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 17, part: 1).split(',').map(int.parse).toList();

day_17_part_1() {
  var data = _processInput();
  Computer computer = Computer(code: data);

  List<List<String>> lines = [];
  List<String> line = [];
  while (!computer.halted) {
    var output = computer.step_until_output();

    if (output == null) break;

    stdout.write(String.fromCharCode(output));
    if (output != 10) {
      line.add(String.fromCharCode(output));
    } else {
      lines.add(line.toList()); // Create copy
      line.clear();
    }
  }

  lines.removeLast(); // Remove last one added wrongly

  // Count intersections
  var acc = 0;
  for (var x = 1; x < lines.length - 1; x++) {
    for (var y = 1; y < lines[0].length - 1; y++) {
      if (lines[x][y] == '#' &&
          lines[x + 1][y] == '#' &&
          lines[x - 1][y] == '#' &&
          lines[x][y + 1] == '#' &&
          lines[x][y - 1] == '#') acc += x * y;
    }
  }

  return acc;
}

// Overly extremely exaggerated hardcoded one-liner thing
day_17_part_2() => [
      (List<int>()
            ..addAll(ascii.encode('A,B,A,B,C,C,B,C,B,A\n'))
            ..addAll(ascii.encode('R,12,L,8,R,12\n'))
            ..addAll(ascii.encode('R,8,R,6,R,6,R,8\n'))
            ..addAll(ascii.encode('R,8,L,8,R,8,R,4,R,4\n'))
            ..addAll(ascii.encode('n\n')))
          .fold(Computer(code: _processInput()..setRange(0, 1, [2])),
              (Computer computer, int input) => computer..addInput(input))
    ]
        .map((computer) => sequence(0, (_) => computer.step_until_output(),
            (current) => current != null))
        .last
        .last;

day_17_part_2_kinda_functional() {
  var data = _processInput();
  data[0] = 2; // Configure initial_value
  Computer computer = Computer(code: data);

  List<int> main_routine = ascii.encode('A,B,A,B,C,C,B,C,B,A\n');
  List<int> routine_A = ascii.encode('R,12,L,8,R,12\n');
  List<int> routine_B = ascii.encode('R,8,R,6,R,6,R,8\n');
  List<int> routine_C = ascii.encode('R,8,L,8,R,8,R,4,R,4\n');
  List<int> see_video_feed = ascii.encode('n\n');

  for (var input in List()
    ..addAll(main_routine)
    ..addAll(routine_A)
    ..addAll(routine_B)
    ..addAll(routine_C)
    ..addAll(see_video_feed)) {
    computer.addInput(input);
  }

  // Run until computer stops
  return sequence(
          0, (_) => computer.step_until_output(), (current) => current != null)
      .last;
}
