import 'dart:io';

/// Generate code stub for main code for AoC [year] [day]
generateCode(int day) => '''
/// Code for the solution of 2019 AoC, day $day.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/$day)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() =>
    readFromFiles(day: $day, part: 1).split('\\n').toList();
    
day_${day}_part_1() {
  var data = _processInput();
}

day_${day}_part_2() {
  var data = _processInput();
}
''';

/// Parse the argument and get day values. days within 1 to 25.
int parseDay(List<String> argumentList) {
  final int day = int.parse(argumentList[0]);
  if (day < 1 || day > 25) throw ArgumentError();

  return day;
}

main(List<String> arguments) {
  try {
    int day = parseDay(arguments);

    var dataFile =
        File('lib/data/day_${day}_1.txt'); // By default, only part 1 file
    var codeFile = File('lib/src/day_${day}.dart');
    var exportFile = File('lib/advent_of_code.dart');
    var markdownFile = File('lib/docs/day_$day.md');

    // Create files if not existent
    if (!dataFile.existsSync()) dataFile.create(recursive: true);
    if (!codeFile.existsSync()) {
      codeFile.create(recursive: true);

      // Add export file line
      exportFile.writeAsStringSync('export \'src/day_$day.dart\';\n',
          mode: FileMode.append);
    }
    if (!markdownFile.existsSync()) markdownFile.create(recursive: true);

    // Write code to file
    codeFile.writeAsStringSync(generateCode(day));
  } on FormatException catch (_) {
    print('Please enter valid number for <year> <day>');
  } on ArgumentError catch (_) {
    print('Invalid values for day (1-25)');
  } catch (e) {
    print("Error: $e");
  }
}
