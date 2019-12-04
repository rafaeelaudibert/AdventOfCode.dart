/// Code for the solution of 2019 AoC, day 4.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/4)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() => readFromFiles(day: 4, part: 1)
    .split('\n')[0]
    .split('-')
    .map((i) => int.parse(i))
    .toList();

List<String> validOnes(int r1, int r2) {
  List<String> valids = List();
  for (var i = r1; i <= r2; i++) {
    var text = i.toString();

    var can = true;
    var two_adjacent = false;

    for (var l = 1; l < text.length; l++) {
      if (text[l] == text[l - 1]) two_adjacent = true;
      if (int.parse(text[l]) < int.parse(text[l - 1])) can = false;
    }

    if (can && two_adjacent) valids.add(text);
  }

  return valids;
}

day_4_part_1() => validOnes(_processInput()[0], _processInput()[1]).length;

day_4_part_2() =>
    validOnes(_processInput()[0], _processInput()[1]).where((text) {
      int curr_seq = 1;
      for (var l = 1; l < text.length; l++) {
        if (text[l] == text[l - 1]) {
          curr_seq++;
        } else if (curr_seq == 2) {
          return true;
        } else {
          curr_seq = 1;
        }
      }

      return curr_seq == 2; // Last one check
    }).length;
