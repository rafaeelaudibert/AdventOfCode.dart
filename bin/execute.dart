import 'dart:isolate';

/// Parse the argument and get day and part values. days
/// should be within 1 to 25 and part between 1 and 2.
List<int> parseArgument(List<String> argumentList) {
  final int day = int.parse(argumentList[0]);
  final int part = int.parse(argumentList[1]);
  if (day < 1 || day > 25) throw ArgumentError();
  if (part < 1 || part > 2) throw ArgumentError();
  return [day, part];
}

void main(List<String> arguments) async {
  try {
    var parsedData = parseArgument(arguments);
    int day = parsedData[0];
    int part = parsedData[1];

    // Create "eval" string
    final uri = Uri.dataFromString(
      '''
      import 'package:advent_of_code/advent_of_code.dart';
      import "dart:isolate";

      void main(_, SendPort port) {
        port.send(day_${day}_part_${part}().toString());
      }
      ''',
      mimeType: 'application/dart',
    );

    // Create port and isolate, to run our "eval" code
    final port = ReceivePort();
    final isolate = await Isolate.spawnUri(uri, [], port.sendPort);

    // Get the response
    final String response = await port.first;

    // Print response
    print(response);

    // Close streams
    port.close();
    isolate.kill();
  } on ArgumentError catch (_) {
    print('Invalid values for day (1-25) or part (1-2)');
  } catch (e) {
    print("Error: $e");
  }
}
