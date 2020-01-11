/// Code for the solution of 2019 AoC, day 7.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/5)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';
import 'dart:math';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 7, part: 1).split(',').map(int.parse).toList();

List<List<int>> generateSettings(int low) {
  var phase_settings = List<List<int>>();
  for (var i in range(0, 5))
    for (var j in range(0, 5))
      for (var k in range(0, 5))
        for (var l in range(0, 5))
          for (var m in range(0, 5))
            phase_settings.add([i + low, j + low, k + low, l + low, m + low]);

  return phase_settings
      .where((phase_setting) => range(low, low + 5).every((number) =>
          phase_setting.where((value) => value == number).length == 1))
      .toList();
}

int day_7_part_1() => generateSettings(0).fold(
    0,
    (maximum, phase_setting) => max(
        maximum,
        phase_setting
            .map(
                (setting) => Computer(code: _processInput())..addInput(setting))
            .fold(
                0,
                (acc, computer) =>
                    (computer..addInput(acc)).step_until_output())));

int day_7_part_1_not_that_functional() {
  var data = _processInput();
  var phase_settings = generateSettings(0);

  int maximum = 0;
  for (var phase_setting in phase_settings) {
    //Create computers
    var computers = phase_setting
        .map((setting) => Computer(code: data)..addInput(setting))
        .toList();

    int output = computers.fold(
        0, (acc, computer) => (computer..addInput(acc)).step_until_output());

    maximum = max(maximum, output);
  }

  return maximum;
}

day_7_part_2() {
  var data = _processInput();
  var phase_settings = generateSettings(5);

  int maximum = 0;
  for (var phase_setting in phase_settings) {
    // Create computers
    var computers = phase_setting
        .map((setting) => Computer(code: data)..addInput(setting))
        .toList();

    // Generate output
    int output = 0;
    while (!computers[0].halted)
      output = computers.fold(
          output,
          (acc, computer) =>
              (computer..addInput(acc)).step_until_output() ?? output);

    maximum = max(maximum, output);
  }

  return maximum;
}
