/// Code for the solution of 2019 AoC, day 22.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/22)
import 'package:advent_of_code/helpers.dart';
import 'package:tuple/tuple.dart';

enum Shuffle { DealIncrement, Cut, DealStack }

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<Tuple2<Shuffle, int>> _processInput() =>
    readFromFiles(day: 22, part: 1).split('\n').map((instr) {
      if (instr.contains('increment'))
        return Tuple2(Shuffle.DealIncrement, int.parse(instr.split(' ').last));

      if (instr.contains('cut'))
        return Tuple2(Shuffle.Cut, int.parse(instr.split(' ').last));

      if (instr.contains('stack')) return Tuple2(Shuffle.DealStack, 0);

      throw FallThroughError();
    }).toList();

const DECK_SIZE = 10007;
day_22_part_1() {
  var shuffles = _processInput();
  var stack = List.generate(DECK_SIZE, (i) => i);

  for (var shuffle in shuffles) {
    var shuffle_type = shuffle.item1;
    var quantity = shuffle.item2;

    switch (shuffle_type) {
      case Shuffle.DealIncrement:
        var new_stack = List.from(stack);
        for (var i in range(0, DECK_SIZE))
          new_stack[(i * quantity) % stack.length] = stack[i];
        stack = List.from(new_stack);
        break;
      case Shuffle.Cut:
        if (quantity >= 0) {
          stack = stack.skip(quantity).toList() + stack.take(quantity).toList();
        } else {
          stack = stack.skip(stack.length + quantity).toList() +
              stack.take(stack.length + quantity).toList();
        }
        break;
      case Shuffle.DealStack:
        stack = stack.reversed.toList();
        break;
    }
  }

  return stack.indexOf(2019);
}

// Part 2 requires modular inverse which I'm not aware of the theory
day_22_part_2() => throw UnimplementedError();
