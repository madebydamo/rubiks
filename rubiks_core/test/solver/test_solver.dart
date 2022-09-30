import 'package:rubiks_core/rubiks_core.dart';
import 'package:rubiks_core/src/solver/algorithms/algorithm_set.dart';
import 'package:test/test.dart';

import '../rubiks_core_test.dart';

void main() async {
  group('Solver', () {
    FileContentLoader? loader;
    setUp(() {
      loader = LocalLoader();
    });

    test('Test create JSON', () {
      // Generation is in ./example
      /* SolverBuilder test = SolverBuilder.start().solvePieces( */
      /*     edges: [EdgePosition.LD], */
      /*     corners: [CornerPosition.LDB, CornerPosition.LDF], */
      /*     depth: 1); */
      /* test.generate(); */
    });
    test('Test solve solvePiece', () async {
      Cube cube = Cube.std();
      cube.turn(Turn("l", halfTurn: true));
      SolverBuilder test = SolverBuilder.start().solvePieces(
          edges: [EdgePosition.LD],
          corners: [CornerPosition.LDB, CornerPosition.LDF],
          depth: 1);
      List<IntermediateSolveState> list = await test.solve(cube, loader!);
      expect(list.length, 24);
      expect(list[0].turns, Turns.fromString("L2"));
      print(list.map((e) => e.turns));
    });
    test('Test solve solveAlgo', () async {
      //T-Perm
      Cube cube =
          Cube("wwwwwwwwgbggggggrrbrrrrrogrbbbbbboooooooyyyyyyyywgrboy");
      SolverBuilder testAlgo = SolverBuilder.start().solveAlgo(CMLL);
      List<IntermediateSolveState> list = await testAlgo.solve(cube, loader!);
      print(list.map((e) => e.turns));
      expect(list.length, 24);
    });
  });
}
