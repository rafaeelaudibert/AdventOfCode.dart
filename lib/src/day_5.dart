/// Code for the solution of 2019 AoC, day 5.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/5)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 5, part: 1).split(',').map((i) => int.parse(i)).toList();

// Global variables to be used on get_parameter
var data = _processInput();
int counter = 0;
int get_parameter(offset, mode) =>
    mode == 0 ? data[data[counter + offset]] : data[counter + offset];

int day_5_part_1({int input = 1}) => day_5_part_2(input: input);

int day_5_part_2({int input = 5}) {
  while (data[counter] != 99) {
    String full_opcode = data[counter].toString().padLeft(5, '0');
    int first_mode = int.parse(full_opcode[2]);
    int second_mode = int.parse(full_opcode[1]);
    // int third_mode = int.parse(full_opcode[0]); // Not actually used
    int opcode = int.parse(full_opcode.substring(3));

    switch (opcode) {
      case 1: // Add
        int param_1 = get_parameter(1, first_mode);
        int param_2 = get_parameter(2, second_mode);
        data[data[counter + 3]] = param_1 + param_2;
        counter += 4;
        break;
      case 2: // Multiply
        int param_1 = get_parameter(1, first_mode);
        int param_2 = get_parameter(2, second_mode);
        data[data[counter + 3]] = param_1 * param_2;
        counter += 4;
        break;
      case 3: // Input
        data[data[counter + 1]] = input;
        counter += 2;
        break;
      case 4: // Output
        print(data[data[counter + 1]]);
        counter += 2;
        break;
      case 5: // Jump if true
        int param_1 = get_parameter(1, first_mode);

        if (param_1 != 0) {
          counter = get_parameter(2, second_mode);
        } else {
          counter += 3;
        }
        break;
      case 6: // Jump if false
        int param_1 = get_parameter(1, first_mode);

        if (param_1 == 0) {
          counter = get_parameter(2, second_mode);
        } else {
          counter += 3;
        }
        break;
      case 7: // Less than
        int param_1 = get_parameter(1, first_mode);
        int param_2 = get_parameter(2, second_mode);

        data[data[counter + 3]] = param_1 < param_2 ? 1 : 0;
        counter += 4;
        break;
      case 8: // Equals
        int param_1 = get_parameter(1, first_mode);
        int param_2 = get_parameter(2, second_mode);

        data[data[counter + 3]] = param_1 == param_2 ? 1 : 0;
        counter += 4;
        break;
      default:
        throw 'Not a good place to be';
    }
  }

  return 0;
}
