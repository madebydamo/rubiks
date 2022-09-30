import 'dart:collection';
import 'dart:html';

import 'package:rubiks_core/rubiks_core.dart';

import '../constants.dart';

List<Element> pieces = querySelectorAll(".piece");
List<String> origTransform = _generateTransforms();
Queue<Turn> turns = Queue();
bool inAnimation = false;

List<String> _generateTransforms() {
  List<String> origTransform = List.empty(growable: true);
  for (var i = 0; i < 26; i++) {
    origTransform.add(
        "rotateX(0deg) translateX(${translateX[i] * 2}em) translateY(${translateY[i] * 2}em) translateZ(${translateZ[i] * 2}em)");
  }
  return origTransform;
}

void showCube(Cube cube) {
  for (var i = 0; i < 26; i++) {
    pieces[i].style.transform = origTransform[i];
  }
  for (var i = 0; i < cube.state.length; i++) {
    DivElement sticker = DivElement();
    sticker.setAttribute("class", "sticker ${colors[cube.state[i]]}");
    Element child = pieces[indexToPiece[i]].children[indexToChildIndex[i]];
    for (var element in child.children) {
      element.remove();
    }
    child.append(sticker);
  }
}

void turnAll(Cube cube, Turns turns) {
  for (Turn singleTurn in turns.turns) {
    turn(cube, singleTurn);
  }
}

void turn(Cube cube, Turn singleTurn) {
  turns.addFirst(singleTurn);
  _turnNext(cube);
}

void _turnNext(Cube cube) {
  Turn turn = turns.last;
  String? axis = turnToAxis[turn.turn.toLowerCase()];
  if (axis == null) {
    turns.removeLast();
    return;
  }

  List<int> indecies = List.empty(growable: true);
  for (var i = 0; i < 26; i++) {
    List<int>? layers = turnToLayer[turn.turn.toLowerCase()];
    List<int>? axisTranslate = translate[axis];
    if (layers != null &&
        axisTranslate != null &&
        layers.contains(axisTranslate[i])) {
      indecies.add(i);
    }
  }
  if (inAnimation) return;
  _animate(cube, indecies, turn, axis);
}

void _animate(Cube cube, List<int> indecies, Turn turn, String axis) {
  inAnimation = true;
  DateTime current = DateTime.now();
  double animationLength = 500.0;
  void rotatePiece(highResTime) {
    int milli =
        DateTime.now().millisecondsSinceEpoch - current.millisecondsSinceEpoch;
    if (milli > animationLength.floor()) {
      inAnimation = false;
      cube.turn(turns.removeLast());
      showCube(cube);
      if (turns.isNotEmpty) {
        _turnNext(cube);
      }
      return;
    }
    double deg = (90 * (milli / animationLength));
    for (var i = 0; i < indecies.length; i++) {
      bool invert = invertDirection[turn.turn.toLowerCase()]!;
      int invertAxis = invert ? -1 : 1;
      int inverted = turn.inverted ? -1 : 1;
      int factorDouble = turn.halfTurn ? 2 : 1;
      pieces[indecies[i]].style.transform =
          "rotate$axis(${invertAxis * inverted * deg * factorDouble}deg) ${origTransform[indecies[i]]}";
    }
    window.requestAnimationFrame(rotatePiece);
  }

  window.requestAnimationFrame(rotatePiece);
}
