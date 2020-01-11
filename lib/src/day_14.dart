/// Code for the solution of 2019 AoC, day 14.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/14)
import 'package:advent_of_code/helpers.dart';
import 'dart:collection';

/// Read the raw [String] content from file and convert it to
/// [List<String>].
List<String> _processInput() =>
    readFromFiles(day: 14, part: 1).split('\n').toList();

Map<String, Map<String, int>> _parseInput(List<String> input) {
  Map<String, Map<String, int>> output = Map();

  output['ORE'] = {'__qtd': 1};
  for (var line in input) {
    var sides = line.split('=>');
    var components = sides[0].trim().split(', ');
    var result_component = sides[1].trim().split(' ')[1];
    var result_quantity = sides[1].trim().split(' ')[0].toInt();

    Map<String, int> components_map = Map();
    for (var component in components) {
      var quantity = component.split(' ')[0].toInt();
      var component_name = component.split(' ')[1];

      components_map[component_name] = quantity;
    }

    components_map['__qtd'] = result_quantity; // Kinda magic argument
    output[result_component] = components_map;
  }

  return output;
}

// Heavily inspired on https://www.reddit.com/user/jeffjeffjeffrey/ answer on Reddit
day_14_part_1({int how_much_fuel = 1}) {
  var recipes = _parseInput(_processInput());

  int ore_necessary = 0;
  Queue<Map<String, int>> orders = Queue.from([
    {'FUEL': how_much_fuel}
  ]);
  Map<String, int> supply = {};

  while (orders.isNotEmpty) {
    var order = orders.removeFirst();
    var order_ingredient = order.keys.first;
    var order_quantity = order[order_ingredient];

    if (order_ingredient == 'ORE') {
      ore_necessary += order_quantity;
    } else if (order_quantity <= (supply[order_ingredient] ?? 0)) {
      supply[order_ingredient] -= order_quantity;
    } else {
      var recipe = recipes[order_ingredient];

      int amount_needed = order_quantity - (supply[order_ingredient] ?? 0);
      int batches = (amount_needed / recipe['__qtd']).ceil();

      for (var ingredient in recipe.keys.where((key) => key != '__qtd'))
        orders.add({ingredient: recipe[ingredient] * batches});

      int leftover = batches * recipe['__qtd'] - amount_needed;
      supply[order_ingredient] = leftover;
    }
  }

  return ore_necessary;
}

day_14_part_2() {
  const GOAL = 1000000000000;
  var start = 1, end = 1000000000;

  // Binary search
  while (start < end) {
    var middle = ((end - start) ~/ 2) + start;
    var ore_necessary = day_14_part_1(how_much_fuel: middle);

    if (ore_necessary > GOAL)
      end = middle - 1;
    else if (ore_necessary < GOAL)
      start = middle + 1;
    else
      return middle;
  }

  // Check if passed from the value or not
  var final_result = day_14_part_1(how_much_fuel: end);
  return GOAL - final_result >= 0 ? end : end - 1;
}
