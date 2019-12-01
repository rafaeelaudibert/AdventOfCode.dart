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
