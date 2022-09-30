import 'dart:io';

import 'package:rubiks_core/rubiks_core.dart';

void main() async {
  /*Generate moves*/
  /* SolverBuilder test = SolverBuilder.start().solvePieces( */
  /*     edges: [EdgePosition.LD], */
  /*     corners: [CornerPosition.LDB, CornerPosition.LDF], */
  /*     depth: 2); */
  /* test.generate(); */
  /* SolverBuilder testAlgo = SolverBuilder.start().solveAlgo(CMLL); */
  /* testAlgo.generate(); */
  LocalLoader loader = LocalLoader();
  roux2.generate(loader);
  /* roux.generate(); */
  Cube cube = Cube.std();
  /* cube.turnList(Turns.fromString("L2DR'FRU2B2FDF'LBR2D'R'LU2L'BDU2R2LFR")); */
  cube.turnList(Turns.fromString("M2"));

  /* List<IntermediateSolveState> list = roux.solve(cube.copy()); */
  /* print(list.map((e) => e.turns)); */
  print("==================================");
  var list = await roux2.solve(cube.copy(), loader);
  print(list.map((e) => e.turns));
}

class LocalLoader extends FileContentLoader {
  @override
  bool exists(String path) {
    File file = File("./lib/$path");
    return file.existsSync();
  }

  @override
  Future<String> getFileContent(String path) {
    File file = File("./lib/$path");
    return file.readAsString();
  }

  @override
  writeFileContent(String path, String content) {
    File file = File("./lib/$path");
    file.writeAsStringSync(content, mode: FileMode.write, flush: true);
  }
}
