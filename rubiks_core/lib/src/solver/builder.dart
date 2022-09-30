import '../model/cube.dart';
import '../model/position.dart';
import 'algorithms/algorithm_set.dart';
import 'solve_configuration.dart';
import 'solve_model.dart';
import 'solver.dart';

class SolverBuilder {
  SolverBuilder? child;
  SolverInterface nextStep;
  List<CornerPosition> solvedCorners;
  List<EdgePosition> solvedEdges;

  SolverBuilder(
      this.child, this.nextStep, this.solvedCorners, this.solvedEdges);

  factory SolverBuilder.start() {
    return SolverBuilder(null, StarterPositions(), [], []);
  }

  SolverBuilder solvePieces({
    List<EdgePosition>? edges,
    List<CornerPosition>? corners,
    int depth = 6,
    List<String>? allowedMoves,
    List<String>? allowedPremoves,
  }) {
    /* this.child =  */
    List<CornerPosition> nextSolvedCorner = solvedCorners.toList();
    List<EdgePosition> nextSolvedEdge = solvedEdges.toList();

    if (corners != null) nextSolvedCorner.addAll(corners);
    if (edges != null) nextSolvedEdge.addAll(edges);

    bool allowPremoves = allowedPremoves != null;
    allowedMoves ??= ["l", "r", "u", "d", "f", "b"];
    allowedPremoves ??= ["l", "r", "u", "d", "f", "b"];

    List<Turn> allowed = allowedMoves.fold([], (prev, elem) {
      prev.add(Turn(
        elem,
      ));
      prev.add(Turn(elem, inverted: true));
      prev.add(Turn(elem, halfTurn: true));
      return prev;
    });
    List<Turn> allowedPre = allowedPremoves.fold([], (prev, elem) {
      prev.add(Turn(
        elem,
      ));
      prev.add(Turn(elem, inverted: true));
      prev.add(Turn(elem, halfTurn: true));
      return prev;
    });

    return SolverBuilder(
        this,
        SolvePiece(corners ?? [], edges ?? [], solvedCorners, solvedEdges,
            depth, allowed, allowPremoves, allowedPre),
        nextSolvedCorner,
        nextSolvedEdge);
  }

  SolverBuilder solveAlgo(AlgorithmSet algo) {
    /* this.child =  */
    List<CornerPosition> nextSolvedCorner = solvedCorners.toList();
    List<EdgePosition> nextSolvedEdge = solvedEdges.toList();

    nextSolvedCorner.addAll(algo.corners);
    nextSolvedEdge.addAll(algo.edges);

    return SolverBuilder(
        this,
        SolveAlgorithm(algo.corners, algo.edges, solvedCorners, solvedEdges,
            algo.premoves, algo.algos),
        nextSolvedCorner,
        nextSolvedEdge);
  }

  SolverBuilder finish() {
    return SolverBuilder(this, SolveFinish(), solvedCorners, solvedEdges);
  }

  void generate(FileContentLoader loader) {
    nextStep.generate(loader);
    if (child != null) child!.generate(loader);
  }

  Future<List<IntermediateSolveState>> solve(Cube cube, FileContentLoader loader) async{
    if (child == null) {
      //Must be StarterPositions
      return nextStep.solveStep(IntermediateSolveState(
          cube, SolveConfiguration.fromCube(cube), Turns.fromString("")), loader);
    }
    List<IntermediateSolveState> resultChild = await child!.solve(cube, loader);
    List<IntermediateSolveState> results = [];
    for (IntermediateSolveState interim in resultChild) {
      results.addAll(await nextStep.solveStep(interim, loader));
    }

    results.sort(
        (a, b) => a.turns.halfTurnMetric.compareTo(b.turns.halfTurnMetric));
    var returnResult = results.take(50).toList();
    print(returnResult.map((e) => e.turns));
    return returnResult;
  }
}

