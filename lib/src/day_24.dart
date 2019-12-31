/// Code for the solution of 2019 AoC, day 24.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/24)
import 'package:advent_of_code/helpers.dart';
import 'dart:math';

/// Read the raw [String] content from file and convert it to
/// a grid of chars in the format of a [List<List<String>>].
List<List<String>> _processInput() => readFromFiles(day: 24, part: 1)
    .split('\n')
    .map((line) => line.substring(0, 5).split(''))
    .toList();

// We will need to have two functions (step and step_recursive)
// as in one of them we can occupy the center square, and in the other not

// While not yet added to the set, step it
// It works because Set.add returns `true` if
// the value has not being added to the set yet
// To make it an one liner, we initialize the Set<String> with a closure
day_24_part_1() => ((layouts) => biodiversity_rating(stringify(step(sequence(
    _processInput(),
    (layout) => step(layout),
    (layout) => layouts.add(stringify(layout))).last))))(Set<String>());

day_24_part_2() {
  var layout = _processInput();
  var empty_layout =
      () => List.generate(5, (_) => List.generate(5, (_) => '.'));

  // There are one on each side to be able to grow,
  // and one left to always have one empty on each side
  // to doesn't have bad memory accesses
  var layouts = [
    empty_layout(),
    empty_layout(),
    layout,
    empty_layout(),
    empty_layout()
  ];

  for (var _ in range(0, 200)) {
    layouts = step_recursive(layouts);

    // Checks need for dynamic list
    if (count_bugs([stringify(layouts[1])]) > 0)
      layouts.insert(0, empty_layout());

    if (count_bugs([stringify(layouts[layouts.length - 2])]) > 0)
      layouts.add(empty_layout());
  }

  return count_bugs(layouts.map((layout) => stringify(layout)).toList());
}

step(List<List<String>> old_layout) {
  var new_layout = old_layout.map((list) => list.toList()).toList(); // Clone it

  for (var y in range(0, 5)) {
    for (var x in range(0, 5)) {
      var adjacent_bugs = 0;
      if (y > 0 && old_layout[y - 1][x] == '#') adjacent_bugs++;
      if (y < 4 && old_layout[y + 1][x] == '#') adjacent_bugs++;
      if (x > 0 && old_layout[y][x - 1] == '#') adjacent_bugs++;
      if (x < 4 && old_layout[y][x + 1] == '#') adjacent_bugs++;

      if (old_layout[y][x] == '#' && adjacent_bugs != 1) {
        // Has bug, kill it
        new_layout[y][x] = '.';
      } else if (old_layout[y][x] == '.' && [1, 2].contains(adjacent_bugs)) {
        // Empty space, infect it
        new_layout[y][x] = '#';
      }
    }
  }

  return new_layout;
}

// Sorry for that
step_recursive(List<List<List<String>>> old_layouts) {
  var new_layouts = old_layouts.toList();

  // Helper to check if there is a bug or not in a stringfied
  // layout representation
  var at = (v, p) => v[p ~/ 5][p % 5] == '#' ? 1 : 0;

  for (var l_idx in range(1, old_layouts.length - 1)) {
    var o = old_layouts[l_idx - 1];
    var l = old_layouts[l_idx]; // Clone it
    var i = old_layouts[l_idx + 1];

    var new_layout =
        old_layouts[l_idx].map((list) => list.toList()).toList(); // Clone it

    for (var y in range(0, 5)) {
      for (var x in range(0, 5)) {
        // Count adjacent bugs
        int adjacent_bugs = 0;
        switch (y * 5 + x) {
          case 0:
            adjacent_bugs = at(o, 11) + at(o, 7) + at(l, 1) + at(l, 5);
            break;
          case 1:
            adjacent_bugs = at(l, 0) + at(o, 7) + at(l, 2) + at(l, 6);
            break;
          case 2:
            adjacent_bugs = at(l, 1) + at(o, 7) + at(l, 3) + at(l, 7);
            break;
          case 3:
            adjacent_bugs = at(l, 2) + at(o, 7) + at(l, 4) + at(l, 8);
            break;
          case 4:
            adjacent_bugs = at(l, 3) + at(o, 7) + at(o, 13) + at(l, 9);
            break;
          case 5:
            adjacent_bugs = at(o, 11) + at(l, 0) + at(l, 6) + at(l, 10);
            break;
          case 6:
            adjacent_bugs = at(l, 5) + at(l, 1) + at(l, 7) + at(l, 11);
            break;
          case 7:
            adjacent_bugs = at(l, 6) +
                at(l, 2) +
                at(l, 8) +
                at(i, 0) +
                at(i, 1) +
                at(i, 2) +
                at(i, 3) +
                at(i, 4);
            break;
          case 8:
            adjacent_bugs = at(l, 7) + at(l, 3) + at(l, 9) + at(l, 13);
            break;
          case 9:
            adjacent_bugs = at(l, 8) + at(l, 4) + at(o, 13) + at(l, 14);
            break;
          case 10:
            adjacent_bugs = at(o, 11) + at(l, 5) + at(l, 11) + at(l, 15);
            break;
          case 11:
            adjacent_bugs = at(l, 10) +
                at(l, 6) +
                at(i, 0) +
                at(i, 5) +
                at(i, 10) +
                at(i, 15) +
                at(i, 20) +
                at(l, 16);
            break;
          case 12:
            adjacent_bugs = 0;
            break;
          case 13:
            adjacent_bugs = at(i, 4) +
                at(i, 9) +
                at(i, 14) +
                at(i, 19) +
                at(i, 24) +
                at(l, 8) +
                at(l, 14) +
                at(l, 18);
            break;
          case 14:
            adjacent_bugs = at(l, 13) + at(l, 9) + at(o, 13) + at(l, 19);
            break;
          case 15:
            adjacent_bugs = at(o, 11) + at(l, 10) + at(l, 16) + at(l, 20);
            break;
          case 16:
            adjacent_bugs = at(l, 15) + at(l, 11) + at(l, 17) + at(l, 21);
            break;
          case 17:
            adjacent_bugs = at(l, 16) +
                at(i, 20) +
                at(i, 21) +
                at(i, 22) +
                at(i, 23) +
                at(i, 24) +
                at(l, 18) +
                at(l, 22);
            break;
          case 18:
            adjacent_bugs = at(l, 17) + at(l, 13) + at(l, 19) + at(l, 23);
            break;
          case 19:
            adjacent_bugs = at(l, 18) + at(l, 14) + at(o, 13) + at(l, 24);
            break;
          case 20:
            adjacent_bugs = at(o, 11) + at(l, 15) + at(l, 21) + at(o, 17);
            break;
          case 21:
            adjacent_bugs = at(l, 20) + at(l, 16) + at(l, 22) + at(o, 17);
            break;
          case 22:
            adjacent_bugs = at(l, 21) + at(l, 17) + at(l, 23) + at(o, 17);
            break;
          case 23:
            adjacent_bugs = at(l, 22) + at(l, 18) + at(l, 24) + at(o, 17);
            break;
          case 24:
            adjacent_bugs = at(l, 23) + at(l, 19) + at(o, 13) + at(o, 17);
            break;
        }

        if (old_layouts[l_idx][y][x] == '#' && adjacent_bugs != 1) {
          // Has bug, kill it
          new_layout[y][x] = '.';
        } else if (old_layouts[l_idx][y][x] == '.' &&
            [1, 2].contains(adjacent_bugs)) {
          // Empty space, infect it
          new_layout[y][x] = '#';
        }

        new_layouts[l_idx] = new_layout;
      }
    }
  }

  return new_layouts;
}

String stringify(List<List<String>> layout) =>
    layout.map((line) => line.join('')).join('');

int biodiversity_rating(String layout) => range(0, layout.length)
    .fold<int>(0, (acc, i) => acc + (layout[i] == '#' ? pow(2, i) : 0));

int count_bugs(List<String> layouts) =>
    layouts.fold<int>(0, (acc, layout) => acc + '#'.allMatches(layout).length);
