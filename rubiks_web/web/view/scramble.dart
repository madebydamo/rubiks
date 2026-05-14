import 'dart:html';
import 'dart:math';

import 'package:rubiks_core/rubiks_core.dart';

import 'cubeView.dart';

class Scramble {
  static late Scramble _scramble;

  Function turn;
  Scramble._(this.turn) {
    Element button = querySelector("#scrambleButton")!;
    button.onClick.listen((event) => scramble());
  }

  factory Scramble(Function turn) {
    _scramble = Scramble._(turn);
    return _scramble;
  }

  void scramble() {
    print("scramble");
    ButtonElement scrambleBtn = querySelector("#scrambleButton")! as ButtonElement;
    ButtonElement solveBtn = querySelector("#solveButton")! as ButtonElement;
    scrambleBtn.disabled = true;
    solveBtn.disabled = true;
    List<String> possibleMoves = ["r", "l", "u", "d", "f", "b"];
    Turns scramble = Turns([]);
    Random random = Random();
    while (scramble.halfTurnMetric < 30) {
      String next;
      bool times2;
      bool invert;
        next = possibleMoves[random.nextInt(6)];
        times2 = random.nextBool();
        invert = random.nextBool();
      Turn nextTurn = Turn(next, halfTurn: times2, inverted: invert);
      scramble.add(nextTurn);
    }
    for (Turn turnSingle in scramble.turns) {
      (turn as Function)(turnSingle, 150.0);
    }
    // re-enable after last turn's animation via timeout approx, but rely on animation end
    // better: listen to animation end but for simplicity use recursive check
    void reEnable() {
      if (inAnimation) {
        Future.delayed(Duration(milliseconds: 100), reEnable);
      } else {
        scrambleBtn.disabled = false;
        solveBtn.disabled = false;
      }
    }
    reEnable();
  }
}
