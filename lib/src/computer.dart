/// Code for the IntCode computer for 2019 AoC.
///
/// The AoC description can be seen [here](https://adventofcode.com/2019)

class Computer {
  // End of execution constant, big enough to not occur normally
  static const int END_OF_EXECUTION = 123412341234;

  // Instruction which causes a HALT
  static const int HALT_INSTRUCTION = 99;

  // Addressing modes
  static const int INDIRECT_MODE = 0;
  static const int DIRECT_MODE = 1;

  // Computer variables
  int _PC = 0;
  List<int> _originalCode = [];
  List<int> _code = [];

  // Constructors
  Computer({List<int> code}) {
    this._originalCode = code.toList();
    this._code = code.toList();
  }

  Computer.withPC({int PC, List<int> code}) {
    this._originalCode = code.toList();
    this._code = code.toList();
    this._PC = PC;
  }

  // Opcode getters
  String get _full_opcode => _code[_PC].toString().padLeft(5, '0');
  int get _opcode => int.parse(_full_opcode.substring(3));

  // Read value from memory
  int _get(addr, mode) =>
      mode == DIRECT_MODE ? _code[addr] : _code[_code[addr]];
  int _set(addr, value) => _code[addr] = value;

  // Configure PC
  void _setPC(val) => _PC = val;
  void _increasePC(val) => _setPC(_PC + val);

  // Public functions
  void resetPC() => _setPC(0);
  void resetCode() => _code = _originalCode.toList();
  bool get halted => _code[_PC] == HALT_INSTRUCTION;

  int step(input) {
    // Read modes earlier
    int first_mode = int.parse(this._full_opcode[2]);
    int second_mode = int.parse(this._full_opcode[1]);
    // int third_mode = int.parse(this._full_opcode[0]); // Not actually used

    // Configure output
    int output = null;

    // Run instruction
    switch (_opcode) {
      case 1: // Add
        int param_1 = this._get(_PC + 1, first_mode);
        int param_2 = this._get(_PC + 2, second_mode);
        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 + param_2);
        this._increasePC(4);
        break;
      case 2: // Multiply
        int param_1 = this._get(_PC + 1, first_mode);
        int param_2 = this._get(_PC + 2, second_mode);
        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 * param_2);
        this._increasePC(4);
        break;
      case 3: // Input
        this._set(this._get(_PC + 1, DIRECT_MODE), input);
        this._increasePC(2);
        break;
      case 4: // Output
        output = this._get(_PC + 1, first_mode);
        this._increasePC(2);
        break;
      case 5: // Jump if true
        int param_1 = this._get(_PC + 1, first_mode);

        param_1 != 0
            ? this._setPC(this._get(_PC + 2, second_mode))
            : this._increasePC(3);
        break;
      case 6: // Jump if false
        int param_1 = this._get(_PC + 1, first_mode);

        param_1 == 0
            ? this._setPC(this._get(_PC + 2, second_mode))
            : this._increasePC(3);
        break;
      case 7: // Less than
        int param_1 = this._get(_PC + 1, first_mode);
        int param_2 = this._get(_PC + 2, second_mode);

        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 < param_2 ? 1 : 0);
        this._increasePC(4);
        break;
      case 8: // Equals
        int param_1 = this._get(_PC + 1, first_mode);
        int param_2 = this._get(_PC + 2, second_mode);

        this._set(this._get(_PC + 3, DIRECT_MODE), param_1 == param_2 ? 1 : 0);
        this._increasePC(4);
        break;
      default:
        throw 'Not a good place to be';
    }

    return output;
  }
}
