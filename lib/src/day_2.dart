/// Code for the solution of 2019 AoC, day 2.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/2)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() =>
    readFromFiles(day: 2, part: 1).split(',').map((i) => int.parse(i)).toList();

int day_2_part_1({noun = 12, verb = 2}) {
  var data = _processInput();

  // As said in the text
  data[1] = noun;
  data[2] = verb;

  int counter = 0;
  while (data[counter] != 99) {
    int opcode = data[counter];
    int load_1 = data[counter + 1];
    int load_2 = data[counter + 2];
    int store = data[counter + 3];

    data[store] =
        opcode == 1 ? data[load_1] + data[load_2] : data[load_1] * data[load_2];
    counter += 4;
  }

  return data[0];
}

int day_2_part_2() {
  for (int i = 0; i < 100; i++) {
    for (int j = 0; j < 100; j++) {
      if (day_2_part_1(noun: i, verb: j) == 19690720) return 100 * i + j;
    }
  }

  throw 'Oops, Not Found!';
}
