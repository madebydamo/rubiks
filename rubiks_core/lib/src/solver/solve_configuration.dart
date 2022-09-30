import '../model/cube.dart';

class SolveConfiguration {
  static final SolveConfiguration std =
      SolveConfiguration.fromCube(Cube.std());
  String f;
  String b;
  String l;
  String r;
  String u;
  String d;

  SolveConfiguration.fromCube(Cube cube)
      : f = cube.state[50],
        b = cube.state[52],
        l = cube.state[49],
        r = cube.state[51],
        u = cube.state[48],
        d = cube.state[53];

  @override
  String toString() {
    return "SolveConfiguration: f: $f, b: $b, l: $l, r: $r, u: $u, d: $d";
  }
}
