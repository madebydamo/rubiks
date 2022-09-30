import '../model/cube.dart';
import '../model/position.dart';
import 'solve_configuration.dart';
import 'solve_model.dart';

abstract class SolverInterface {
  Future<List<IntermediateSolveState>> solveStep(IntermediateSolveState interim, FileContentLoader loader);
  void generate(FileContentLoader loader);
}

class SolvePiece implements SolverInterface {
  List<CornerPosition> solvedCorners;
  List<EdgePosition> solvedEdges;
  List<CornerPosition> newCorners;
  List<EdgePosition> newEdges;
  List<Turn> allowedMoves;
  List<Turn> allowedPremoves;
  bool allowPremoves;
  /* File? _file; */
  LookupTable? _table;

  int counter = 0;

  int depth;

  SolvePiece(
      this.newCorners,
      this.newEdges,
      this.solvedCorners,
      this.solvedEdges,
      this.depth,
      this.allowedMoves,
      this.allowPremoves,
      this.allowedPremoves) {
    solvedCorners.sort();
    solvedEdges.sort();
    newCorners.sort();
    newEdges.sort();
  }

  String _getFileName() {
    solvedCorners.sort();
    solvedEdges.sort();
    newEdges.sort();
    newCorners.sort();
    String solvedEdgesStr = solvedEdges.fold(
        "", (previousValue, element) => "$element$previousValue");
    String solvedCornersStr = solvedCorners.fold(
        "", (previousValue, element) => "$element$previousValue");
    String newEdgesStr =
        newEdges.fold("", (previousValue, element) => "$element$previousValue");
    String newCornersStr = newCorners.fold(
        "", (previousValue, element) => "$element$previousValue");
    return "asset$solvedEdgesStr$solvedCornersStr$newEdgesStr$newCornersStr.json";
  }

  @override
  Future<List<IntermediateSolveState>> solveStep(IntermediateSolveState interim, FileContentLoader loader) async {
    /* _file ??= File(); */
    _table ??=
        LookupTable.fromJson(await loader.getFileContent("/data/${_getFileName()}"));
    List<IntermediateSolveState> result = [];
    int i = 0;
    do {
      for (IntermediateSolveState ss in _getAllCombinations(i, interim)) {
        result.addAll(_resolveStep(ss));
      }
      i++;
    } while (i <= 3 && result.isEmpty && allowPremoves);
    return result;
  }

  List<IntermediateSolveState> _getAllCombinations(
      int depth, IntermediateSolveState interim) {
    if (depth == 0) return [interim];
    List<IntermediateSolveState> result = [];
    int premoveLength = interim.turns.halfTurnMetric;
    for (var move in allowedPremoves) {
      IntermediateSolveState copy = interim.copyAddTurns(Turns([move]));
      if (copy.turns.halfTurnMetric <= premoveLength) continue;
      result.addAll(_getAllCombinations(depth - 1, copy));
    }
    return result;
  }

  List<IntermediateSolveState> _resolveStep(IntermediateSolveState interim) {
    List<IntermediateSolveState> result = [];
    result.addAll(_table!
        .getTurns(interim.cube, newEdges, newCorners, interim.conf)
        .map((e) => interim.copyAddTurns(e)));

    return result;
  }

  @override
  void generate(FileContentLoader loader) {
    /* _file ??= File("./data/${_getFileName()}"); */
    if (loader.exists("/data/${_getFileName()}")) return;
    counter = 0;
    Cube cube = Cube.std();
    _table = LookupTable();
    _generateMove(depth, cube, Turns([]));

    /* if (!_file!.existsSync()) _file!.create(recursive: true); */
    /* _file! */
    /*     .writeAsStringSync(_table!.toJson(), mode: FileMode.write, flush: true); */

    loader.writeFileContent("/data/${_getFileName()}", _table!.toJson());
  }

  void _generateMove(int depth, Cube cube, Turns premove) {
    Cube std = Cube.std();
    bool correctEdges = solvedEdges.fold(true, (previousValue, element) {
      if (!previousValue) return false;
      String identifier = element.getDominant(SolveConfiguration.std);
      int posStd = std.getEdgePosition(
          element.getEdge(SolveConfiguration.std), identifier);
      int posCube = cube.getEdgePosition(
          element.getEdge(SolveConfiguration.std), identifier);
      return posStd == posCube;
    });
    bool correct = solvedCorners.fold(correctEdges, (previousValue, element) {
      if (!previousValue) return false;
      String identifier = element.getDominant(SolveConfiguration.std);
      int posStd = std.getCornerPosition(
          element.getCorner(SolveConfiguration.std), identifier);
      int posCube = cube.getCornerPosition(
          element.getCorner(SolveConfiguration.std), identifier);
      return posStd == posCube;
    });
    if (correct) {
      Turns add = premove.copy();
      add.invert();
      _table!.addTurn(cube, newEdges, newCorners, SolveConfiguration.std, add);
    }

    counter++;
    if (counter % 65536 == 0) print(counter);
    if (depth == 0) return;
    /* analyzer(cube, moves); */
    int premoveLength = premove.halfTurnMetric;
    for (var move in allowedMoves) {
      Turns copy = premove.copy();
      copy.add(move);
      if (copy.halfTurnMetric <= premoveLength) continue;
      cube.turn(move);
      _generateMove(depth - 1, cube, copy);
      cube.revertTurn(move);
    }
  }
}

class SolveAlgorithm extends SolverInterface {
  List<CornerPosition> solvedCorners;
  List<EdgePosition> solvedEdges;
  List<CornerPosition> newCorners;
  List<EdgePosition> newEdges;
  List<Turns> premoves;
  List<Turns> algorithmSet;
  /* File? _file; */
  LookupTable? _table;

  SolveAlgorithm(this.newCorners, this.newEdges, this.solvedCorners,
      this.solvedEdges, this.premoves, this.algorithmSet) {
    solvedCorners.sort();
    solvedEdges.sort();
    newCorners.sort();
    newEdges.sort();
  }

  @override
  void generate(FileContentLoader loader) {
    /* _file ??= File("./data/${_getFileName()}"); */
    if (loader.exists("/data/${_getFileName()}")) return;
    Cube std = Cube.std();
    _table = LookupTable();
    for (Turns algo in algorithmSet) {
      for (Turns premove in premoves) {
        for (Turns postMove in premoves) {
          Cube cube = std.copy();
          Turns turns = premove.copy();
          turns.addTurns(algo);
          turns.addTurns(postMove);
          cube.turnList(turns);
          _add(cube, turns);
        }
      }
    }
    /* if (!_file!.existsSync()) _file!.create(recursive: true); */
    /* _file!.writeAsString(_table!.toJson(), mode: FileMode.write, flush: true); */
    loader.writeFileContent("/data/${_getFileName()}", _table!.toJson());
  }

  String _getFileName() {
    solvedCorners.sort();
    solvedEdges.sort();
    newEdges.sort();
    newCorners.sort();
    String solvedEdgesStr = solvedEdges.fold(
        "", (previousValue, element) => "$element$previousValue");
    String solvedCornersStr = solvedCorners.fold(
        "", (previousValue, element) => "$element$previousValue");
    String newEdgesStr =
        newEdges.fold("", (previousValue, element) => "$element$previousValue");
    String newCornersStr = newCorners.fold(
        "", (previousValue, element) => "$element$previousValue");
    return "algo$solvedEdgesStr$solvedCornersStr$newEdgesStr$newCornersStr.json";
  }

  void _add(Cube cube, Turns turns) {
    Cube std = Cube.std();
    bool correctEdges = solvedEdges.fold(true, (previousValue, element) {
      if (!previousValue) return false;
      String identifier = element.getDominant(SolveConfiguration.std);
      int posStd = std.getEdgePosition(
          element.getEdge(SolveConfiguration.std), identifier);
      int posCube = cube.getEdgePosition(
          element.getEdge(SolveConfiguration.std), identifier);
      return posStd == posCube;
    });
    bool correct = solvedCorners.fold(correctEdges, (previousValue, element) {
      if (!previousValue) return false;
      String identifier = element.getDominant(SolveConfiguration.std);
      int posStd = std.getCornerPosition(
          element.getCorner(SolveConfiguration.std), identifier);
      int posCube = cube.getCornerPosition(
          element.getCorner(SolveConfiguration.std), identifier);
      return posStd == posCube;
    });
    if (correct) {
      Turns add = turns.copy();
      add.invert();
      _table!.addTurn(cube, newEdges, newCorners, SolveConfiguration.std, add,
          onlySmallest: false);
    }
  }

  @override
  Future<List<IntermediateSolveState>> solveStep(IntermediateSolveState interim, FileContentLoader loader) async {
    /* _file ??= File("./data/${_getFileName()}"); */
    _table ??=
        LookupTable.fromJson(await loader.getFileContent("/data/${_getFileName()}"));
    List<IntermediateSolveState> result = [];
    result.addAll(_table!
        .getTurns(interim.cube, newEdges, newCorners, interim.conf)
        .map((e) => interim.copyAddTurns(e)));

    return result;
  }
}

class StarterPositions implements SolverInterface {
  final Set<Turns> starterPosition = {
    Turns.fromStrings([]),
    Turns.fromStrings(["x"]),
    Turns.fromStrings(["x2"]),
    Turns.fromStrings(["x'"]),
    Turns.fromStrings(["y"]),
    Turns.fromStrings(["y", "x"]),
    Turns.fromStrings(["y", "x2"]),
    Turns.fromStrings(["y", "x'"]),
    Turns.fromStrings(["y'"]),
    Turns.fromStrings(["y'", "x"]),
    Turns.fromStrings(["y'", "x2"]),
    Turns.fromStrings(["y'", "x'"]),
    Turns.fromStrings(["y2"]),
    Turns.fromStrings(["y2", "x"]),
    Turns.fromStrings(["y2", "x2"]),
    Turns.fromStrings(["y2", "x'"]),
    Turns.fromStrings(["z"]),
    Turns.fromStrings(["z", "x"]),
    Turns.fromStrings(["z", "x2"]),
    Turns.fromStrings(["z", "x'"]),
    Turns.fromStrings(["z'"]),
    Turns.fromStrings(["z'", "x"]),
    Turns.fromStrings(["z'", "x2"]),
    Turns.fromStrings(["z'", "x'"])
  };
  @override
  Future<List<IntermediateSolveState>> solveStep(IntermediateSolveState interim, FileContentLoader loader) async {
    List<IntermediateSolveState> positions = [];
    for (var turns in starterPosition) {
      Cube cube = interim.cube.copy();
      cube.turnList(turns);
      positions.add(IntermediateSolveState(
          cube, SolveConfiguration.fromCube(cube), turns));
    }
    return positions;
  }

  @override
  void generate(FileContentLoader loader) {}
}

class SolveFinish implements SolverInterface {
  static final List<EdgePosition> _edges = [
    EdgePosition.LU,
    EdgePosition.LD,
    EdgePosition.LF,
    EdgePosition.LB,
    EdgePosition.RU,
    EdgePosition.RD,
    EdgePosition.RF,
    EdgePosition.RB,
    EdgePosition.UF,
    EdgePosition.UB,
    EdgePosition.DF,
    EdgePosition.DB,
  ];
  static final List<CornerPosition> _corners = [
    CornerPosition.LUF,
    CornerPosition.LUB,
    CornerPosition.LDF,
    CornerPosition.LDB,
    CornerPosition.RUF,
    CornerPosition.RUB,
    CornerPosition.RDF,
    CornerPosition.RDB,
  ];
  @override
  void generate(FileContentLoader loader) {}

  @override
  Future<List<IntermediateSolveState>> solveStep(IntermediateSolveState interim, FileContentLoader loader) async {
    Cube std = Cube.std();
    bool result = true;
    for (EdgePosition e in _edges) {
      result &= interim.cube.getEdgePosition(
              e.getEdge(interim.conf), e.getDominant(interim.conf)) ==
          std.getEdgePosition(e.getEdge(SolveConfiguration.std),
              e.getDominant(SolveConfiguration.std));
    }
    for (CornerPosition c in _corners) {
      result &= interim.cube.getCornerPosition(
              c.getCorner(interim.conf), c.getDominant(interim.conf)) ==
          std.getCornerPosition(c.getCorner(SolveConfiguration.std),
              c.getDominant(SolveConfiguration.std));
    }
    result &= interim.conf.f == interim.cube.state[50];
    result &= interim.conf.b == interim.cube.state[52];
    result &= interim.conf.l == interim.cube.state[49];
    result &= interim.conf.r == interim.cube.state[51];
    result &= interim.conf.u == interim.cube.state[48];
    result &= interim.conf.d == interim.cube.state[53];
    if (result) {
      return [interim];
    }
    return [];
  }
}
