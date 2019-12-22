/// Code for the solution of 2019 AoC, day 16.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/16)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 16, part: 1).split('').map((n) => int.parse(n)).toList();

const PATTERN = [0, 1, 0, -1];

day_16_part_1() {
  var data = _processInput();

  for (var i = 0; i < 100; i++) {
    List<int> new_data = List(data.length);

    for (var idx = 1; idx <= data.length; idx++) {
      int acc = 0;
      for (var n = 0; n < data.length; n++) {
        var pattern_multiplier = PATTERN[((n + 1) ~/ idx) % PATTERN.length];
        acc += data[n] * pattern_multiplier;
      }
      String parsed_acc = "$acc";
      int last_digit = int.parse(parsed_acc[parsed_acc.length - 1]);

      new_data[idx - 1] = last_digit;
    }

    data = new_data.toList(); // Create copy
  }

  return data.take(8).join('');
}

// Need to use a god-damn optimization that I'm not aware of the needed Math, sorry
day_16_part_2() {
  throw UnimplementedError();
}
