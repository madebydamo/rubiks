import 'dart:html';

class Pivot {
  static final Pivot _pivot = Pivot._();

  num _x;
  num _y;
  Pivot._()
      : _x = -35,
        _y = -25;

  factory Pivot() {
    return _pivot;
  }

  void reset() {
    x = -35;
    y = -25;
  }

  void backside() {
    x = 145;
    y = 25;
  }

  void enableTransition() {
    querySelector("#pivot")!.style.transitionDuration = "0.5s";
  }

  void disableTransition() {
    querySelector("#pivot")!.style.transitionDuration = "0.0s";
  }

  set x(num x) {
    _x = x;
    _updatePivot();
  }

  num get x => _x;

  set y(num y) {
    _y = y;
    _updatePivot();
  }

  num get y => _y;

  void _updatePivot() {
    // x and y must be switched, dont ask me why
    querySelector("#pivot")!.style.transform = "rotateX(${_y}deg) rotateY(${_x}deg)";
  }
}
