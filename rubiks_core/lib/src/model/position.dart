import '../solver/solve_configuration.dart';
import 'cube.dart';

abstract class Position implements Comparable {
  final bool l;
  final bool r;
  final bool f;
  final bool b;
  final bool u;
  final bool d;

  Position(
      {this.l = false,
      this.r = false,
      this.f = false,
      this.b = false,
      this.u = false,
      this.d = false});

  @override
  int compareTo(other) {
    if (this is CornerPosition && other is CornerPosition) {
      return _value().compareTo(other._value());
    }
    if (this is EdgePosition && other is EdgePosition) {
      return _value().compareTo(other._value());
    }
    if (this is EdgePosition && other is CornerPosition) {
      return -1;
    }
    return 1;
  }

  String getDominant(SolveConfiguration conf);

  int _value() {
    int result = 0;
    if (l) result += 1;
    if (r) result += 2;
    if (f) result += 4;
    if (b) result += 8;
    if (u) result += 16;
    if (d) result += 32;
    return result;
  }
}

class CornerPosition extends Position {
  static CornerPosition get LUF => CornerPosition(l: true, u: true, f: true);
  static CornerPosition get LUB => CornerPosition(l: true, u: true, b: true);
  static CornerPosition get LDF => CornerPosition(l: true, d: true, f: true);
  static CornerPosition get LDB => CornerPosition(l: true, d: true, b: true);
  static CornerPosition get RUF => CornerPosition(r: true, u: true, f: true);
  static CornerPosition get RUB => CornerPosition(r: true, u: true, b: true);
  static CornerPosition get RDF => CornerPosition(r: true, d: true, f: true);
  static CornerPosition get RDB => CornerPosition(r: true, d: true, b: true);

  CornerPosition(
      {super.l = false,
      super.r = false,
      super.f = false,
      super.b = false,
      super.u = false,
      super.d = false});

  @override
  String getDominant(SolveConfiguration conf) {
    return l ? conf.l : conf.r;
  }

  Corner getCorner(SolveConfiguration conf) {
    return Corner(
        l ? conf.l : conf.r, u ? conf.u : conf.d, f ? conf.f : conf.b);
  }

  @override
  String toString() {
    return "c${_value()}";
  }
}

class EdgePosition extends Position {
  static final EdgePosition LU = EdgePosition(l: true, u: true);
  static final EdgePosition LD = EdgePosition(l: true, d: true);
  static final EdgePosition LF = EdgePosition(l: true, f: true);
  static final EdgePosition LB = EdgePosition(l: true, b: true);
  static final EdgePosition RU = EdgePosition(r: true, u: true);
  static final EdgePosition RD = EdgePosition(r: true, d: true);
  static final EdgePosition RF = EdgePosition(r: true, f: true);
  static final EdgePosition RB = EdgePosition(r: true, b: true);
  static final EdgePosition UF = EdgePosition(u: true, f: true);
  static final EdgePosition UB = EdgePosition(u: true, b: true);
  static final EdgePosition DF = EdgePosition(d: true, f: true);
  static final EdgePosition DB = EdgePosition(d: true, b: true);

  EdgePosition(
      {super.l = false,
      super.r = false,
      super.f = false,
      super.b = false,
      super.u = false,
      super.d = false});
  Edge getEdge(SolveConfiguration conf) {
    return Edge(l ? conf.l : (r ? conf.r : (u ? conf.u : conf.d)),
        f ? conf.f : (b ? conf.b : (u ? conf.u : conf.d)));
  }

  @override
  String getDominant(SolveConfiguration conf) {
    return l ? conf.l : (r ? conf.r : (u ? conf.u : conf.d));
  }

  @override
  String toString() {
    return "e${_value()}";
  }

}
