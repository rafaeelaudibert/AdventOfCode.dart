/// Code for the solution of 2019 AoC, day 22.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/22)
import 'package:advent_of_code/helpers.dart';
import 'package:tuple/tuple.dart';

// ShuffleType enum and Shuffle class
enum ShuffleType { DealIncrement, Cut, DealStack }

class Shuffle {
  final ShuffleType shuffleType;
  final int quantity;
  Shuffle(this.shuffleType, [this.quantity = 0]);
}

/// Read the raw [String] content from file and convert it to
/// [Iterable<Tuple2<Shuffle, int>>].
Iterable<Shuffle> _processInput() =>
    readFromFiles(day: 22, part: 1).split('\n').map((instr) {
      if (instr.contains('increment'))
        return Shuffle(
            ShuffleType.DealIncrement, instr.split(' ').last.toInt());

      if (instr.contains('cut'))
        return Shuffle(ShuffleType.Cut, instr.split(' ').last.toInt());

      if (instr.contains('stack')) return Shuffle(ShuffleType.DealStack);

      throw FallThroughError();
    });

const DECK_SIZE = 10007;
day_22_part_1() {
  var shuffles = _processInput();
  var stack = List.generate(DECK_SIZE, (i) => i);

  for (var shuffle in shuffles) {
    switch (shuffle.shuffleType) {
      case ShuffleType.DealIncrement:
        final new_stack = stack.clone();
        for (final i in range(0, DECK_SIZE))
          new_stack[(i * shuffle.quantity) % stack.length] = stack[i];
        stack = new_stack;
        break;
      case ShuffleType.Cut:
        final cut_size = (stack.length + shuffle.quantity) % stack.length;
        stack = stack.skip(cut_size).toList() + stack.take(cut_size).toList();
        break;
      case ShuffleType.DealStack:
        stack = stack.reversed.toList();
        break;
    }
  }

  return stack.indexOf(2019);
}

// Based on [/u/metalim](https://www.reddit.com/user/metalim/) Python code, available
// [here](https://github.com/metalim/metalim.adventofcode.2019.python/blob/master/22_cards_shuffle.ipynb)
day_22_part_2() {
  var data = _processInput().toList();

  var L = 119315717514047.toBigInt();
  var N = 101741582076661.toBigInt();
  return shuffle2(L, N, 2020, data);
}

// convert rules to linear polynomial.
// (g∘f)(x) = g(f(x))
Tuple2<BigInt, BigInt> parse(BigInt L, List<Shuffle> shuffles) {
  var a = BigInt.one, b = BigInt.zero;
  for (var shuffle in shuffles.reversed) {
    var quantity = shuffle.quantity.toBigInt();

    switch (shuffle.shuffleType) {
      case ShuffleType.DealIncrement:
        quantity = quantity.modInverse(L);
        a = a * quantity % L;
        b = b * quantity % L;
        break;
      case ShuffleType.Cut:
        b = (b + quantity) % L; // Unnecessary parenthesis, here for legibility
        break;
      case ShuffleType.DealStack:
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

int shuffle2(BigInt L, BigInt N, int pos, List<Shuffle> rules) {
  var parsed = parse(L, rules);
  parsed = polypow(parsed.item1, parsed.item2, N, L);
  return (pos * parsed.item1.toInt() + parsed.item2.toInt()) % L.toInt();
}
