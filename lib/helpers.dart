import 'dart:io';

/// Returns input data from text file. Takes [day] and [part].
///
/// I copy the data from the input section and paste it in
/// the file under `lib/data` in the format `day_<day>_<part>.txt`.
/// This file parsed that and loads the [String] content.
///
/// ```dart
/// readFromFiles(day: 2, part: 1);```
String readFromFiles({day, part}) =>
    File('./lib/data/day_${day}_${part}.txt').readAsStringSync();

/// Return a range between [start] and [end]
List<int> range(int start, int end) =>
    new List<int>.generate(end - start, (i) => i + start);

/// Create a sequence, given an initial [seed],
/// until a [condition] is reached
Iterable<T> sequence<T>(
    T seed, T next(T current), bool condition(T current)) sync* {
  for (var current = seed; condition(current); current = next(current))
    yield current;
}

/// Generate all the possible tuples from a [list]
Iterable<List<T>> generate_tuples<T>(List<T> list) sync* {
  for (var i in range(0, list.length))
    for (var j in range(0, list.length)) if (i != j) yield [list[i], list[j]];
}

/// [Point] class
class Point {
  int x, y;
  Point(this.x, this.y);

  int dist(Point p) => (p.x - this.x).abs() + (p.y + this.y).abs();

  bool operator ==(covariant Point o) => o.x == this.x && o.y == this.y;
  int get hashCode => this.x.hashCode ^ this.y.hashCode;
  String toString() => '<x=$x, y=$y>';
}
