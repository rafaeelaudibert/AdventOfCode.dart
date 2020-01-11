/// Code for the solution of 2019 AoC, day 16.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/16)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 16, part: 1).split('').map((n) => int.parse(n)).toList();

const PATTERN = [0, 1, 0, -1];
const NUM_PHASES = 100;
const MULTIPLIER = 10000;
const OFFSET_DIGITS = 7;
const MESSAGE_SIZE = 8;

day_16_part_1() {
  var data = _processInput();

  for (var i = 0; i < NUM_PHASES; i++) {
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

  return data.take(MESSAGE_SIZE).join('');
}

// Based on [ExtremeBreakfast5](https://www.reddit.com/user/ExtremeBreakfast5/) Python implementation
// available [here](https://topaz.github.io/paste/#XQAAAQCcCwAAAAAAAAA0m0pnuFI8c+fPp4HB1KdZ5eFWD1VYmJWe9xkvfbjYYzCdzzWruPBbteW/ueKh1tReLlkGjRZ9zyj1Hlyjuz0s8UgMbdm1avNXj6I7EM0ERFKgPrHpgM3fxd6GWRB8RxbX8FVfy9vbamhqtKpsES89SV4Vou5EVqpd5Brym3pX5SHX1TuLdkr2MZ1CVUPiA5hM2c+PFHm5+pCkI+kVmzauNXcjo87BOu6vTLTYHp4sHfQ/h0e3BSFJ9Cnw4aIrQZLhF8ms0EMGeA7gCpdChCA5bVGOjnVCvKlPuu8odniL3CMruE/aN+GmaKKLwrXXpeP9BYlslWN/O8rVD+GObmLSIItA4V3YFjZHbii4KLvw723/PpXFU3PtrzfobGKmXiTCMublHjyl3gUXxQPI1lvSr1YRbFlawz7hW4YlLho0z4Wj27u+D9invu73qjn0BBnXJL/7SKMYcum2UFtFqhXia/MzL75Oxb59j/tVsndWBQc720B+9Ee7aZgmetF68cwQ9OQZF7Aj8PkEki/w/k2HJqIfyX5t8P+IdknwgShdoAm8oFw57oz5/Z1dVCxrah0Ach88TWQZR4u4CdgiZNQ9uOmBWnM+Dv5pODvm6qkaIb30pMwV65yRcehIuWKKq3GC0drAfnecjszExv8eujPWCxDDWyqOLVmE+FRw5FJSzqVJe/Gah7ov5BWjqigsDbuoLD+fXnIqxuIRZNoovsVYtFiuClZIIvNXUvwnsCYblAmzShkhAxpqNgK76BSfCdq+/8ke0vluIbYEJKgSMHJUL0za6NyuS33UMCxTsyp1/hQtXoX9a+RoposKOGAYGqb2b07Fbxpmenv84fPv9MFjXCOp2D7WRKh6nbs5Pk+M9b9u26rJHT8TPq9384bak9I3hdtJtWj/qsrmxMOCEYX1CHwBEcCOqXKfg54KOn7xhNT2pOOLpe2W6ctScxShwvMr80sAxjP7lpyn51ER0PMSCHv3PIoq8YLt7A1QaGqshTtEEVV8JOmIXxywxiAhmzR/Ku5QNLLfyNYrKioJpqcMgTcy7SHspR0ZHMJ6q8P2bIJ6WkytnaWdTXcnXgtqxbFgwhNr6Mm42ICJFgX7uoKpEGmZV9CPoDQMXQZgJsZ/MElLUJWBDAaZme9jMOef/tnTRcfCSpMfN4x/dG5g9eybAikLIg0+N60FSyJmwI5Gnahbdr7K1ULX8NcyHW1WGagp57kyGibiKI+TTzPwyUTzkO883+8B6TE0b7h9hbVWOLvA3X7IUJhh96cvrgWl6tLjnI60nJt1FnM8seoTOaU4NMyjOt51smYVR0abNA+NNSLDJC3Ghqx7k9x5z09t6EV/3cTZbCgKI8GRRELdkA1bGDjwekFGk4ugvUm3qhE3KJ0tJoAx4m+X5IzDbWIIbyuhTH1IHC6GtdX2JD+NVb6YUI0eRGnpP/liI/areI8lr0hwCd3Frn8i/oJQnfQZv14+ajkonea1KrnIx9oopNvKsG9IhrFrP8WWZ2n4BFT7zP3MyXqOMeq3/0CwYUv2B8zbHIZUWNQxgyO3Vpkbkfh8VFKWFaFSscLDTHBw2BTJ7DQ4bC3aY//gS4e7)
day_16_part_2() {
  var data = _processInput();
  var message_offset = data.take(OFFSET_DIGITS).join('').toInt();
  var data_length = data.length * MULTIPLIER;
  assert(
      message_offset > data_length / 2, 'There is no fast way to solve this');
  var necessary_length = data_length - message_offset;
  var num_copies = (necessary_length / data.length).ceil();
  data = List.generate(num_copies, (_) => data.toList())
      .expand((x) => x)
      .skip(data.length * num_copies - necessary_length)
      .toList();

  for (var _ in range(0, NUM_PHASES)) {
    var sum = 0;

    for (var j = data.length - 1; j >= 0; j--)
      data[j] = sum = (sum + data[j]) % 10;
  }

  return data.take(MESSAGE_SIZE).join('');
}
