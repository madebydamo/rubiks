import 'dart:html';
import 'package:rubiks_core/rubiks_core.dart';

import 'view/cubeView.dart';
import 'view/pivot.dart';
import 'view/scramble.dart';
import 'view/solve.dart';

Element scene = querySelector("#scene")!;
Cube cube = Cube.std();
Pivot pivot = Pivot();
Point<num>? start;
Point<num>? startPivot;

void main() {
  showCube(cube);
  Scramble((Turn turnS) => turn(cube, turnS));
  document.onKeyDown.listen(keydown);
  initRotation();
  Solve(() => cube, (Turn turns) => turn(cube, turns));
}

void initRotation() {
  scene.onMouseDown.listen((event) {
    if (start != null || startPivot != null) return;
    start = Point(event.page.x, event.page.y);
    startPivot = Point(pivot.x, pivot.y);
    pivot.disableTransition();
  });
  scene.onTouchStart.listen((event) {
    if (start != null || startPivot != null) return;
    Touch? touch = event.touches?[0];
    if (touch != null) {
      start = Point(touch.page.x, touch.page.y);
      startPivot = Point(pivot.x, pivot.y);
      pivot.disableTransition();
    }
  });
  scene.onMouseMove.listen((event) {
    if (start == null || startPivot == null) return;
    move(event.page.x, event.page.y);
  });
  scene.onTouchMove.listen((event) {
    if (start == null || startPivot == null) return;
    Touch? touch = event.touches?[0];
    if (touch != null) {
      move(touch.page.x, touch.page.y);
    }
  });
  document.onMouseUp.listen((event) {
    start = null;
    startPivot = null;
    pivot.enableTransition();
  });
  document.onTouchEnd.listen((event) {
    start = null;
    startPivot = null;
    pivot.enableTransition();
  });
}

void move(num x, num y) {
  pivot.x = startPivot!.x + (x - start!.x) / 2;
  pivot.y = startPivot!.y - (y - start!.y) / 2;
}

void keydown(KeyboardEvent event) {
  String? key = event.key;
  if (key != null) {
    if (key == "0") {
      Pivot().reset();
      return;
    } else if (key == "9") {
      Pivot().backside();
    }
    turn(cube, Turn(key));
  }
}
