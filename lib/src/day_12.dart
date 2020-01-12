/// Code for the solution of 2019 AoC, day 12.
///
/// Problem description can be seen [here](https://adventofcode.com/2019/day/12)
import 'package:advent_of_code/helpers.dart';

/// Read the raw [String] content from file and convert it to
/// [Iterable<String>].
Iterable<String> _processInput() => readFromFiles(day: 12, part: 1).split('\n');

// LCM helper
int lcm(int a, int b) => a * b ~/ a.gcd(b);

// Regex used to parse string
RegExp get_integer = RegExp('-?[0-9]+');

class Moon {
  int x, y, z;
  int v_x = 0, v_y = 0, v_z = 0;

  Moon(String input) {
    this.x = get_integer.firstMatch(input.split(',')[0]).group(0).toInt();
    this.y = get_integer.firstMatch(input.split(',')[1]).group(0).toInt();
    this.z = get_integer.firstMatch(input.split(',')[2]).group(0).toInt();
  }

  Moon.with_cords(this.x, this.y, this.z);

  applyAllGs(List<Moon> moons) {
    moons.forEach((moon) {
      if (moon != this) this.applyG(moon);
    });
  }

  applyG(Moon o) {
    // For X
    if (this.x < o.x) {
      this.v_x++;
    } else if (this.x > o.x) {
      this.v_x--;
    }

    // For Y
    if (this.y < o.y) {
      this.v_y++;
    } else if (this.y > o.y) {
      this.v_y--;
    }

    // For Z
    if (this.z < o.z) {
      this.v_z++;
    } else if (this.z > o.z) {
      this.v_z--;
    }
  }

  applyV() {
    this.x += this.v_x;
    this.y += this.v_y;
    this.z += this.v_z;
  }

  get pos => "$x,$y,$z";
  get vel => "$v_x,$v_y,$v_z";
  get potential_energy => this.x.abs() + this.y.abs() + this.z.abs();
  get kinetic_energy => this.v_x.abs() + this.v_y.abs() + this.v_z.abs();
  get total_energy => potential_energy * kinetic_energy;
}

day_12_part_1() {
  const int STEPS = 1000;
  List<Moon> moons = _processInput().map((moon_str) => Moon(moon_str)).toList();

  for (int i = 0; i < STEPS; i++) {
    moons.forEach((moon) => moon.applyAllGs(moons));
    moons.forEach((moon) => moon.applyV());
  }

  return moons.map((moon) => moon.total_energy).reduce((acc, val) => acc + val);
}

day_12_part_2() {
  List<Moon> moons = _processInput().map((moon_str) => Moon(moon_str)).toList();

  // Get initial position representation for each axis
  String x_start = moons.map((moon) => moon.x).join(',');
  String y_start = moons.map((moon) => moon.y).join(',');
  String z_start = moons.map((moon) => moon.z).join(',');
  int x_interval = null, y_interval = null, z_interval = null;

  int i = 1;
  while (true) {
    i++;

    // Update moons
    moons.forEach((moon) => moon.applyAllGs(moons));
    moons.forEach((moon) => moon.applyV());

    // Get axis representations
    String x_i = moons.map((moon) => moon.x).join(',');
    String y_i = moons.map((moon) => moon.y).join(',');
    String z_i = moons.map((moon) => moon.z).join(',');

    // Check for their interval
    if (x_start == x_i && x_interval == null) x_interval = i;
    if (y_start == y_i && y_interval == null) y_interval = i;
    if (z_start == z_i && z_interval == null) z_interval = i;

    if (x_interval != null && y_interval != null && z_interval != null) break;
  }

  return lcm(lcm(x_interval, y_interval), z_interval);
}
