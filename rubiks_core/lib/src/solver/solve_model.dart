import 'dart:convert';

import '../model/cube.dart';
import '../model/position.dart';
import 'solve_configuration.dart';

class IntermediateSolveState {
  Cube cube;
  SolveConfiguration conf;
  Turns turns;
  IntermediateSolveState(this.cube, this.conf, this.turns);

  IntermediateSolveState copyAddTurns(Turns turns) {
    Cube copyC = cube.copy();
    copyC.turnList(turns);
    Turns copyT = this.turns.copy();
    copyT.addTurns(turns);
    return IntermediateSolveState(copyC, conf, copyT);
  }
}

class LookupTable {
  final Map<String, List<Turns>> _map = {};

  LookupTable();
  LookupTable.fromJson(String s) {
    var json = jsonDecode(s);
    if (json is Map) {
      for (String key in json.keys) {
        if (json[key] is List<dynamic>) {
          var turnsString = json[key]!;
          List<Turns> turns = [];
          for (var turn in turnsString) {
            if (turn is String) {
              turns.add(Turns.fromString(turn));
            }
          }
          _map[key] = turns;
        }
      }
    }
  }

  List<Turns> getTurns(Cube cube, List<EdgePosition> edges,
      List<CornerPosition> corners, SolveConfiguration config) {
    String identifier = _getIdentifier(cube, edges, corners, config);
    return _map[identifier] ?? [];
  }

  void addTurn(Cube cube, List<EdgePosition> edges,
      List<CornerPosition> corners, SolveConfiguration config, Turns turns,
      {bool onlySmallest = true}) {
    String identifier = _getIdentifier(cube, edges, corners, config);
    if (_map.containsKey(identifier)) {
      int size = _map[identifier]!.first.halfTurnMetric;
      if (onlySmallest) {
        if (size > turns.halfTurnMetric) {
          _map[identifier] = [turns];
        } else if (size == turns.halfTurnMetric) {
          if (!_map[identifier]!.contains(turns)) {
            _map[identifier]!.add(turns);
          }
        }
      } else {
        _map[identifier]!.add(turns);
      }
    } else {
      _map[identifier] = [turns];
    }
  }

  String _getIdentifier(Cube cube, List<EdgePosition> edges,
      List<CornerPosition> corners, SolveConfiguration config) {
    String edgeString = edges.map((e) {
      Edge edge = e.getEdge(config);
      return cube.getEdgePosition(edge, e.getDominant(config));
    }).fold("", (previousValue, element) => "$previousValue,$element");
    String cornerString = corners.map((e) {
      Corner corner = e.getCorner(config);
      return cube.getCornerPosition(corner, e.getDominant(config));
    }).fold("", (previousValue, element) => "$previousValue,$element");
    return edgeString + cornerString;
  }

  String toJson() {
    return json.encode(_map, toEncodable: (e) {
      if (e is Turns) {
        return e.toString();
      }
      return "";
    });
  }
}

abstract class FileContentLoader {
  Future<String> getFileContent(String path);
  writeFileContent(String path, String content);
  bool exists(String path);
}
