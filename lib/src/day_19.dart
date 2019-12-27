/// Code for the solution of 2019 AoC, day 19.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/19)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 19, part: 1).split(',').map(int.parse).toList();

day_19_part_1() {
  var data = _processInput();

  List<int> laser_beam = [];
  for (var i in range(0, 50))
    for (var j in range(0, 50))
      laser_beam.add(
          (Computer(code: data)..addInput(i)..addInput(j)).step_until_output());

  return laser_beam.where((int val) => val == 1).length;
}

const MATRIX_SIZE = 2000;
const INITIAL =
    782; // Maybe need to change this, but for my input it works exactly from here
day_19_part_2() {
  var data = _processInput();

  List<List<int>> laser_beam =
      List.generate(MATRIX_SIZE, (_) => List.filled(MATRIX_SIZE, 0));
  print('Finished generating matrix');
  for (int i = INITIAL; i < MATRIX_SIZE; i++) {
    bool found_it = false;
    for (int j = INITIAL; j < MATRIX_SIZE; j++) {
      laser_beam[i][j] =
          (Computer(code: data)..addInput(i)..addInput(j)).step_until_output();

      // Mark that found the beam
      if (laser_beam[i][j] == 1) found_it = true;

      // If passed the laser_beam, end it
      if (found_it && laser_beam[i][j] == 0) break;
    }

    int laser_start = laser_beam[i].indexOf(1);
    if (laser_start != -1 && i >= 99) {
      int laser_size_x = laser_beam[i].where((n) => n == 1).length;
      int laser_size_y =
          laser_beam.map((row) => row[laser_start]).where((n) => n == 1).length;

      if (laser_size_x >= 100 &&
          laser_size_y >= 100 &&
          i >= 99 &&
          laser_beam[i - 99][laser_start] == 1 &&
          laser_beam[i - 99][laser_start + 99] == 1)
        return (i - 99) * 10000 + laser_start;
    }
  }

  throw FallThroughError();
}
