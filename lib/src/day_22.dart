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
        return Tuple2(Shuffle.DealIncrement, instr.split(' ').last.toInt());

      if (instr.contains('cut'))
        return Tuple2(Shuffle.Cut, instr.split(' ').last.toInt());

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

// Based on [/u/metalim](https://www.reddit.com/user/metalim/) Python code, available
// [here](https://github.com/metalim/metalim.adventofcode.2019.python/blob/master/22_cards_shuffle.ipynb)
day_22_part_2() {
  var data = _processInput();

  var L = BigInt.from(119315717514047);
  var N = BigInt.from(101741582076661);
  return shuffle2(L, N, 2020, data);
}

// convert rules to linear polynomial.
// (g∘f)(x) = g(f(x))
Tuple2<BigInt, BigInt> parse(BigInt L, List<Tuple2<Shuffle, int>> shuffles) {
  var a = BigInt.one, b = BigInt.zero;
  for (var shuffle in shuffles.reversed) {
    var shuffle_type = shuffle.item1;
    var quantity = BigInt.from(shuffle.item2);

    switch (shuffle_type) {
      case Shuffle.DealIncrement:
        quantity = quantity.modInverse(L);
        a = a * quantity % L;
        b = b * quantity % L;
        break;
      case Shuffle.Cut:
        b = (b + quantity) % L;
        break;
      case Shuffle.DealStack:
        a = -a;
        b = L - b - BigInt.one;
        break;
    }
  }

  return Tuple2(a, b);
}

// modpow the polynomial: (ax+b)^m % n
// f(x) = ax+b
// g(x) = cx+d
// f^2(x) = a(ax+b)+b = aax + ab+b
// f(g(x)) = a(cx+d)+b = acx + ad+b
Tuple2<BigInt, BigInt> polypow(BigInt a, BigInt b, BigInt m, BigInt n) {
  if (m == BigInt.zero) return Tuple2(BigInt.one, BigInt.zero);
  if (m.isEven) return polypow(a * a % n, (a * b + b) % n, m ~/ BigInt.two, n);

  var tuple = polypow(a, b, m - BigInt.one, n);
  return Tuple2(a * tuple.item1 % n, (a * tuple.item2 + b) % n);
}

int shuffle2(BigInt L, BigInt N, int pos, List<Tuple2<Shuffle, int>> rules) {
  var parsed = parse(L, rules);
  parsed = polypow(parsed.item1, parsed.item2, N, L);
  return (pos * parsed.item1.toInt() + parsed.item2.toInt()) % L.toInt();
}
