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

day_4_part_1() {
  var data = _processInput();
  var r1 = data[0];
  var r2 = data[1];

  var counter = 0;
  for (var i = r1; i <= r2; i++) {
    var text = i.toString();

    var can = true;
    var two_adjacent = false;
    for (var l = 1; l < text.length; l++) {
      if (text[l] == text[l - 1]) two_adjacent = true;
      if (int.parse(text[l]) < int.parse(text[l - 1])) can = false;
    }
    if (can && two_adjacent) counter++;
  }

  return counter;
}

day_4_part_2() {
  var data = _processInput();
  var r1 = data[0];
  var r2 = data[1];

  var counter = 0;
  for (var i = r1; i <= r2; i++) {
    var text = i.toString();

    var can = true;
    var two_adjacent = false;
    Set<int> seqs = Set();
    int curr_seq = 1;
    for (var l = 1; l < text.length; l++) {
      if (int.parse(text[l]) < int.parse(text[l - 1]))
        can = false; // Decreasing

      if (text[l] == text[l - 1]) {
        // Equal to the last
        two_adjacent = true;
        curr_seq++;
      } else {
        seqs.add(curr_seq);
        curr_seq = 1;
      }
    }
    seqs.add(curr_seq); // Add the last one

    if (can && two_adjacent && seqs.contains(2)) counter++;
  }

  return counter;
}
