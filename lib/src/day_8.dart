/// Code for the solution of 2019 AoC, day 8.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/8)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [String] (trivial).
String _processInput() => readFromFiles(day: 8, part: 1);

const PIXELS_WIDE = 25;
const PIXELS_TALL = 6;
const TOTAL_PIXELS = PIXELS_WIDE * PIXELS_TALL;

day_8_part_1() {
  var data = _processInput();
  int layers = data.length ~/ TOTAL_PIXELS;

  int minimum = TOTAL_PIXELS + 1;
  int minimum_idx = 0;
  for (var i = 0; i < layers; i++) {
    String slice = data.substring(TOTAL_PIXELS * i, (TOTAL_PIXELS * (i + 1)));
    int one_quantity = slice.split('').where((digit) => digit == '0').length;

    if (one_quantity < minimum) {
      minimum = one_quantity;
      minimum_idx = i;
    }
  }

  List layer = data
      .substring(TOTAL_PIXELS * minimum_idx, (TOTAL_PIXELS * (minimum_idx + 1)))
      .split('');

  return layer.where((digit) => digit == '1').length *
      layer.where((digit) => digit == '2').length;
}

day_8_part_2() {
  var data = _processInput();
  int layers = data.length ~/ TOTAL_PIXELS;

  List image = List.filled(TOTAL_PIXELS, '2');
  for (var i = 0; i < layers; i++) {
    String slice = data.substring(TOTAL_PIXELS * i, TOTAL_PIXELS * (i + 1));
    for (var j = 0; j < TOTAL_PIXELS; j++) {
      if (image[j] == '2') image[j] = slice[j];
    }
  }

  String imageString =
      image.map((number) => number == '1' ? '#' : ' ').join('');
  for (var i = 0; i < PIXELS_TALL; i++)
    print(imageString.substring(PIXELS_WIDE * i, PIXELS_WIDE * (i + 1)));

  return 0;
}
