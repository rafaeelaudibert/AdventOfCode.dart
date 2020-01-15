/// Code for the IntCode computer for 2019 AoC.
///
/// The AoC description can be seen [here](https://adventofcode.com/2019)
import 'dart:collection';
import 'dart:convert';
import 'package:advent_of_code/helpers.dart';

enum Opcode {
  Add,
  Multiply,
  Input,
  Output,
  JumpIfTrue,
  JumpIfFalse,
  LessThan,
  Equals,
  ChangeRelativeBase,
  Halt,
  Invalid
}

class Computer {
  // Instruction which causes a HALT
  static const int HALT_INSTRUCTION = 99;

  // Addressing modes
  static const int INDIRECT_MODE = 0;
  static const int DIRECT_MODE = 1;
  static const int RELATIVE_MODE = 2;

  // Computer variables
  int _PC = 0;
  int _relative_base = 0;
  Map<int, int> _originalCode;
  Map<int, int> _code;
  Queue<int> _inputs = Queue();

  // Debug
  bool _debug;
  int inputs_consumed = 0;

  // Constructors
  Computer({List<int> code, debug = false}) {
    this._originalCode = Map.from(code.asMap());
    this._code = Map.from(code.asMap());
    this._debug = debug;
  }

  // Opcode and input getters
  String get _full_opcode => _code[_PC].toString().padLeft(5, '0');
  int _raw_opcode;
  Opcode get _opcode {
    this._raw_opcode = _full_opcode.substring(3).toInt();

    // Minus 2 because of halt and invalid
    if (this._raw_opcode <= Opcode.values.length - 2)
      return Opcode.values[this._raw_opcode - 1];

    if (this._raw_opcode == HALT_INSTRUCTION) return Opcode.Halt;

    return Opcode.Invalid;
  }

  int get _input {
    this.inputs_consumed++;
    return this._inputs.length > 0 ? this._inputs.removeFirst() : -1;
  }

  // Read value from memory
  int _get_parameter(int parameter, int mode) => _get(_PC + parameter, mode);
  int _get(int addr, int mode) {
    switch (mode) {
      case INDIRECT_MODE:
        return _code[_code[addr] ?? 0] ?? 0;
      case DIRECT_MODE:
        return _code[addr] ?? 0;
      case RELATIVE_MODE:
        return _code[(_code[addr] ?? 0) + this._relative_base] ?? 0;
      default:
        throw 'Invalid base';
    }
  }

  void _set(int addr, int value, int mode) => mode == RELATIVE_MODE
      ? _code[addr + this._relative_base] = value
      : _code[addr] = value;

  // Configure PC
  void _setPC(int val) => _PC = val;
  void _increasePC(int val) => _setPC(_PC + val);

  // Public functions
  bool get halted => _opcode == Opcode.Halt;
  void addInput(int input_value) => _inputs.addLast(input_value);
  void clearInput() => this._inputs.clear();
  void resetPC() => _setPC(0);
  void reset() {
    _code = Map.from(_originalCode);
    resetPC();
    this._inputs.clear();
  }

  // Ascii Helper functions
  void addAsciiInput(String str) => str
      .split('')
      .forEach((input_value) => _inputs.addLast(ascii.encode(input_value)[0]));
  String step_until_ascii_output() =>
      String.fromCharCode(this.step_until_output() ?? 0);

  // Step functions
  int step_until_output() {
    while (!halted) {
      int inputs_consumed_before = this.inputs_consumed;
      int curr_input = _inputs.length > 0 ? _inputs.first : null;
      int output = this.step();

      // Return output correctly
      if (output != null) return output;

      // Is waiting for some input
      if (inputs_consumed_before < this.inputs_consumed && curr_input == null)
        return null;
    }

    return null;
  }

  int step() {
    // Read modes earlier
    int first_mode = this._full_opcode[2].toInt();
    int second_mode = this._full_opcode[1].toInt();
    int third_mode = this._full_opcode[0].toInt();

    // Configure output
    int output = null;

    // Run instruction
    switch (_opcode) {
      case Opcode.Add:
        int param_1 = _get_parameter(1, first_mode);
        int param_2 = _get_parameter(2, second_mode);
        this._set(
            this._get(_PC + 3, DIRECT_MODE), param_1 + param_2, third_mode);

        if (_debug)
          print(
              'Summed $param_1 and $param_2 and stored at ${this._get(_PC + 3, DIRECT_MODE)}');

        this._increasePC(4);
        break;
      case Opcode.Multiply:
        int param_1 = _get_parameter(1, first_mode);
        int param_2 = _get_parameter(2, second_mode);
        this._set(
            this._get(_PC + 3, DIRECT_MODE), param_1 * param_2, third_mode);

        if (_debug)
          print(
              'Summed $param_1 and $param_2 and stored at ${this._get(_PC + 3, DIRECT_MODE)}');

        this._increasePC(4);
        break;
      case Opcode.Input:
        this._set(this._get_parameter(1, DIRECT_MODE), _input, first_mode);

        if (_debug)
          print(
              'Stored ${this._get(_PC + 1, first_mode)} at ${this._get(_PC + 1, DIRECT_MODE)}');

        this._increasePC(2);
        break;
      case Opcode.Output:
        output = _get_parameter(1, first_mode);

        if (_debug) print('Outputed $output');

        this._increasePC(2);
        break;
      case Opcode.JumpIfTrue:
        int param_1 = _get_parameter(1, first_mode);

        if (_debug) print('Jump if true with value $param_1');

        param_1 != 0
            ? this._setPC(this._get(_PC + 2, second_mode))
            : this._increasePC(3);
        break;
      case Opcode.JumpIfFalse:
        int param_1 = _get_parameter(1, first_mode);

        if (_debug) print('Jump if false with value $param_1');

        param_1 == 0
            ? this._setPC(this._get(_PC + 2, second_mode))
            : this._increasePC(3);
        break;
      case Opcode.LessThan:
        int param_1 = _get_parameter(1, first_mode);
        int param_2 = _get_parameter(2, second_mode);

        if (_debug) print('Check if $param_1 less than $param_2');

        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 < param_2 ? 1 : 0,
            third_mode);
        this._increasePC(4);
        break;
      case Opcode.Equals:
        int param_1 = _get_parameter(1, first_mode);
        int param_2 = _get_parameter(2, second_mode);

        if (_debug) print('Check if $param_1 equals to $param_2');

        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 == param_2 ? 1 : 0,
            third_mode);
        this._increasePC(4);
        break;
      case Opcode.ChangeRelativeBase:
        this._relative_base += this._get_parameter(1, first_mode);

        if (_debug) print('Relative base now at $_relative_base');
        this._increasePC(2);
        break;
      case Opcode.Halt:
        break;
      default:
        if (_debug) print("Invalid opcode $_raw_opcode");
        throw 'Invalid opcode';
    }

    return output;
  }
}
