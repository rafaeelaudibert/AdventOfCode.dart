/// Code for the solution of 2019 AoC, day 13.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/13)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 13, part: 1).split(',').map(int.parse).toList();

day_13_part_1() {
  var data = _processInput();
  var computer = Computer(code: data);

  Set<String> places = Set();
  while (!computer.halted) {
    var x = computer.step_until_output();
    var y = computer.step_until_output();
    var tile = computer.step_until_output();

    if (tile == 2) places.add("$x,$y");
  }

  return places.length;
}

day_13_part_2() {
  var data = _processInput();
  data[0] = 2;
  var computer = Computer(code: data);

  int score = 0;
  int ballPos = 0, padPos = 0;
  int sideToSend = 0;

  while (!computer.halted) {
    // Clear and set input
    computer
      ..clearInput()
      ..addInput(sideToSend);

    var x = computer.step_until_output();
    var y = computer.step_until_output();
    var tile = computer.step_until_output();

    if (x == -1 && y == 0) {
      score = tile;
    } else {
      if (tile == 3) padPos = x;
      if (tile == 4) ballPos = x;

      sideToSend = (ballPos - padPos) > 0 ? 1 : (ballPos - padPos) < 0 ? -1 : 0;
    }
  }

  return score;
}
