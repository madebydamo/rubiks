import 'package:rubiks_core/rubiks_core.dart';
import 'package:test/test.dart';

void main() {
  group('Cube', () {
    setUp(() {
      // Additional setup goes here.
    });

    test('Turn and Backturn', () {
      Cube cube = Cube.std();
      String orignState = cube.state;
      cube.turn(Turn("r"));
      cube.turn(Turn("r", inverted: true));
      expect(cube.state, orignState);
    });
    test("Turns from String and Strings", () {
      Turns turnsString = Turns.fromString("LMR2L'SE'FB'UD");
      Turns turnsStrings = Turns.fromStrings(
          ["L", "M", "R2", "L'", "S", "E'", "F", "B'", "U", "D"]);
      expect(turnsString, turnsStrings);
    });
    test("Turns to String", () {
      String s = "LMR2L'SE'FB'ud";
      Turns turns = Turns.fromString(s);
      expect(turns.toString(), s.toUpperCase());
    });
  });
}
