import 'dart:html';
import 'dart:math';

import 'package:rubiks_core/rubiks_core.dart';

import 'cubeView.dart';

class Solve {
  static late Solve _solve;

  Function getCube;
  Function turn;
  Solve._(this.getCube, this.turn) {
    Element button = querySelector("#solveButton")!;
    button.onClick.listen((event) => solve());
  }

  factory Solve(Function getCube, Function turn) {
    _solve = Solve._(getCube, turn);
    return _solve;
  }

  void solve() async {
    ButtonElement scrambleBtn = querySelector("#scrambleButton")! as ButtonElement;
    ButtonElement solveBtn = querySelector("#solveButton")! as ButtonElement;
    scrambleBtn.disabled = true;
    solveBtn.disabled = true;
    List<IntermediateSolveState> solution =
        await roux2.solve(getCube(), WebContentLoader());
    if (solution.isNotEmpty) {
      for (Turn turnSingle in solution[0].turns.turns) {
        turn(turnSingle);
      }
    }
    void reEnable() {
      if (isBusy()) {
        Future.delayed(Duration(milliseconds: 100), reEnable);
      } else {
        scrambleBtn.disabled = false;
        solveBtn.disabled = false;
      }
    }
    reEnable();
  }
}

class WebContentLoader extends FileContentLoader {
  @override
  bool exists(String path) {
    // TODO: implement exists
    throw UnimplementedError();
  }

  @override
  Future<String> getFileContent(String path) {
    return HttpRequest.getString("$path");
  }

  @override
  writeFileContent(String path, String content) {
    //Web is read only
    throw UnimplementedError();
  }
}
