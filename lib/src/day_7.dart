/// Code for the solution of 2019 AoC, day 7.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/5)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 7, part: 1).split(',').map((i) => int.parse(i)).toList();

// Global range helper
const range = [0, 1, 2, 3, 4];

List<List<int>> generateSettings(int low) {
  var phase_settings = List<List<int>>();
  for (var i in range)
    for (var j in range)
      for (var k in range)
        for (var l in range)
          for (var m in range)
            phase_settings.add([i + low, j + low, k + low, l + low, m + low]);

  return phase_settings;
}

int day_7_part_1() {
  var data = _processInput();
  var phase_settings = generateSettings(0);
  var computers = [
    Computer(code: data),
    Computer(code: data),
    Computer(code: data),
    Computer(code: data),
    Computer(code: data)
  ];

  int maximum = 0;
  for (var phase_setting in phase_settings) {
    if (range.every((number) =>
        phase_setting.where((value) => value == number).length == 1)) {
      var output_1 = compute_thruster(phase_setting[0], 0);
      var output_2 = compute_thruster(phase_setting[1], output_1);
      var output_3 = compute_thruster(phase_setting[2], output_2);
      var output_4 = compute_thruster(phase_setting[3], output_3);
      var output_5 = compute_thruster(phase_setting[4], output_4);

      if (output_5 > maximum) {
        maximum = output_5;
      }
    }
  }

  return maximum;
}

int compute_thruster(input_1, input_2) {
  // Private function
  int get_parameter(offset, mode, data, counter) =>
      mode == 0 ? data[data[counter + offset]] : data[counter + offset];

  var data = _processInput();
  int counter = 0;
  bool send_input_1 = true;

  while (data[counter] != 99) {
    String full_opcode = data[counter].toString().padLeft(5, '0');
    int first_mode = int.parse(full_opcode[2]);
    int second_mode = int.parse(full_opcode[1]);
    // int third_mode = int.parse(full_opcode[0]); // Not actually used
    int opcode = int.parse(full_opcode.substring(3));

    switch (opcode) {
      case 1: // Add
        int param_1 = get_parameter(1, first_mode, data, counter);
        int param_2 = get_parameter(2, second_mode, data, counter);
        data[data[counter + 3]] = param_1 + param_2;
        counter += 4;
        break;
      case 2: // Multiply
        int param_1 = get_parameter(1, first_mode, data, counter);
        int param_2 = get_parameter(2, second_mode, data, counter);
        data[data[counter + 3]] = param_1 * param_2;
        counter += 4;
        break;
      case 3: // Input
        data[data[counter + 1]] = send_input_1 ? input_1 : input_2;
        send_input_1 = false; // Prepare for next input
        counter += 2;
        break;
      case 4: // Output
        return data[data[counter + 1]];
      case 5: // Jump if true
        int param_1 = get_parameter(1, first_mode, data, counter);

        if (param_1 != 0) {
          counter = get_parameter(2, second_mode, data, counter);
        } else {
          counter += 3;
        }
        break;
      case 6: // Jump if false
        int param_1 = get_parameter(1, first_mode, data, counter);

        if (param_1 == 0) {
          counter = get_parameter(2, second_mode, data, counter);
        } else {
          counter += 3;
        }
        break;
      case 7: // Less than
        int param_1 = get_parameter(1, first_mode, data, counter);
        int param_2 = get_parameter(2, second_mode, data, counter);

        data[data[counter + 3]] = param_1 < param_2 ? 1 : 0;
        counter += 4;
        break;
      case 8: // Equals
        int param_1 = get_parameter(1, first_mode, data, counter);
        int param_2 = get_parameter(2, second_mode, data, counter);

        data[data[counter + 3]] = param_1 == param_2 ? 1 : 0;
        counter += 4;
        break;
      default:
        throw 'Not a good place to be';
    }
  }

  throw 'Shouldn\'t be here';
}

// Not implemented
day_7_part_2() {
  throw UnimplementedError();
}
