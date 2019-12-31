/// Code for the solution of 2019 AoC, day 23.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/23)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';

/// Read the raw [String] content from file and convert it to
/// [List<int>].
List<int> _processInput() =>
    readFromFiles(day: 23, part: 1).split(',').map(int.parse).toList();

day_23_part_1() => run_network(use_nat: false);

day_23_part_2() => run_network(use_nat: true);

run_network({use_nat: false}) {
  var data = _processInput();
  var computers = List<Computer>.generate(
      50,
      (i) => Computer(code: data)
        ..addInput(i)
        ..step_until_output());

  // Mimic the NAT is a Point, to have X and Y
  Point NAT = Point(0, 0);
  int last_nat_value = null;
  while (true) {
    var is_idle = true;

    for (var i in range(0, computers.length)) {
      while (!computers[i].halted) {
        var address = computers[i].step_until_output();

        // Go ahead, as this computer is waiting for packets
        if (address == null) break;

        // Mark input as received
        is_idle = false;

        var x = computers[i].step_until_output();
        var y = computers[i].step_until_output();

        // Check if we should configure the NAT or send a packet
        if (address != 255) {
          computers[address]..addInput(x)..addInput(y);
        } else if (use_nat) {
          NAT = Point(x, y);
        } else {
          return y;
        }
      }
    }

    // Should activate NAT to send packet to computer 0
    if (is_idle) {
      if (last_nat_value == NAT.y) return NAT.y;
      last_nat_value = NAT.y;

      computers[0]..addInput(NAT.x)..addInput(NAT.y);
    }
  }
}
