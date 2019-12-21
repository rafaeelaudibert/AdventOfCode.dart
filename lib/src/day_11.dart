/// Code for the solution of 2019 AoC, day 11.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/11)
import 'package:advent_of_code/helpers.dart';
import 'computer.dart';
import 'dart:io';

enum Color { Black, White }
enum Facing { Up, Right, Bottom, Left }

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<int> _processInput() => readFromFiles(day: 11, part: 1)
    .split(',')
    .map((n) => int.parse(n))
    .toList();

String updatePosition(String position, Facing facing) {
  switch (facing) {
    case Facing.Up:
      return "${position.split(',')[0]},${int.parse(position.split(',')[1]) + 1}";
    case Facing.Right:
      return "${int.parse(position.split(',')[0]) + 1},${position.split(',')[1]}";
    case Facing.Bottom:
      return "${position.split(',')[0]},${int.parse(position.split(',')[1]) - 1}";
    case Facing.Left:
      return "${int.parse(position.split(',')[0]) - 1},${position.split(',')[1]}";
  }

  throw FallThroughError();
}

Facing updateFacing(Facing facing, int direction) {
  if (direction == 0) {
    switch (facing) {
      case Facing.Up:
        return Facing.Left;
      case Facing.Right:
        return Facing.Up;
      case Facing.Bottom:
        return Facing.Right;
      case Facing.Left:
        return Facing.Bottom;
    }
  } else {
    switch (facing) {
      case Facing.Up:
        return Facing.Right;
      case Facing.Right:
        return Facing.Bottom;
      case Facing.Bottom:
        return Facing.Left;
      case Facing.Left:
        return Facing.Up;
    }
  }

  throw FallThroughError();
}

Map<String, Color> paintShip({Color initial_position = Color.Black}) {
  var data = _processInput();
  var computer = Computer(code: data);

  Map<String, Color> positions = {'0,0': initial_position};
  String position = '0,0';
  Facing current_facing = Facing.Up;
  while (!computer.halted) {
    // Add inputs and get outputs
    computer.addInput(
        positions[position] == Color.Black || positions[position] == null
            ? 0
            : 1);
    int output = computer.step_until_output();
    int direction = computer.step_until_output();

    // Update color
    positions[position] = output == 0 ? Color.Black : Color.White;

    // Update direction
    current_facing = updateFacing(current_facing, direction);

    // Update position
    position = updatePosition(position, current_facing);
  }

  return positions;
}

day_11_part_1() => paintShip().length;

day_11_part_2() {
  var positions = paintShip(initial_position: Color.White);

  // Paint the ship in the terminal
  for (int y = 5; y >= -10; y--) {
    for (int x = -5; x <= 45; x++) {
      stdout.write(positions["$x,$y"] == Color.White ? '#' : ' ');
    }
    stdout.write('\n');
  }

  return positions.length;
}
