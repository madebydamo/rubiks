import 'package:quiver/collection.dart';

import '../constants.dart';

class Corner {
  Set<String> set;

  Corner(String c1, String c2, String c3) : set = {c1, c2, c3};
  @override
  int get hashCode => set.hashCode;

  String get identifier => set.fold(
      "a",
      (previousValue, element) =>
          previousValue.compareTo(element) == 1 ? previousValue : element);

  @override
  bool operator ==(Object other) =>
      other is Corner &&
      other.runtimeType == runtimeType &&
      setsEqual(other.set, set);
}

class Cube {
  static const String _std =
      "wwwwwwwwggggggggrrrrrrrrbbbbbbbbooooooooyyyyyyyywgrboy";
  String state;

  Cube(this.state);

  factory Cube.std() {
    return Cube(_std);
  }

  Cube copy() {
    return Cube(state);
  }

  int getCornerPosition(Corner wanted, String s) {
    for (List<int> corner in corners) {
      Corner candidate = Corner(
          state[corner[0] - 1], state[corner[1] - 1], state[corner[2] - 1]);
      if (candidate == wanted) {
        return s == state[corner[0] - 1]
            ? corner[0]
            : s == state[corner[1] - 1]
                ? corner[1]
                : corner[2];
      }
    }

    return 0;
  }

  int getEdgePosition(Edge wanted, String s) {
    for (List<int> edge in edges) {
      Edge candidate = Edge(state[edge[0] - 1], state[edge[1] - 1]);
      if (candidate == wanted) {
        return s == state[edge[0] - 1] ? edge[0] : edge[1];
      }
    }

    return 0;
  }

  Cube revertTurn(Turn move) {
    return turn(move.invert());
  }

  Cube revertTurnList(Turns turns) {
    Turns inverted = turns.copy();
    inverted.invert();
    return turnList(inverted);
  }

  Cube turn(Turn turn) {
    List<List<int>>? stickerCycle = turnToStickerCycle[turn.turn.toLowerCase()];
    if (stickerCycle == null) {
      return this;
    }

    void cycle(List<int> cycleList) {
      if (turn.inverted) cycleList = cycleList.reversed.toList();
      String temp = state[cycleList[3] - 1];
      state = state.replaceRange(
          cycleList[3] - 1, cycleList[3], state[cycleList[2] - 1]);
      state = state.replaceRange(
          cycleList[2] - 1, cycleList[2], state[cycleList[1] - 1]);
      state = state.replaceRange(
          cycleList[1] - 1, cycleList[1], state[cycleList[0] - 1]);
      state = state.replaceRange(cycleList[0] - 1, cycleList[0], temp);
    }

    for (var element in stickerCycle) {
      cycle(element);
      if (turn.halfTurn) {
        cycle(element);
      }
    }
    return this;
  }

  Cube turnList(Turns turns) {
    for (Turn turnSingle in turns._turns) {
      turn(turnSingle);
    }
    return this;
  }
}

class Edge {
  Set<String> set;

  Edge(String c1, String c2) : set = {c1, c2};
  String get dominant => set.fold(
      "a",
      (previousValue, element) =>
          previousValue.compareTo(element) == 1 ? previousValue : element);

  @override
  int get hashCode => set.hashCode;

  @override
  bool operator ==(Object other) => other is Edge && setsEqual(set, other.set);
}

class Turn {
  String turn;
  bool halfTurn;
  bool inverted;
  Turn(String turnString, {this.halfTurn = false, this.inverted = false})
      : turn = turnString.toUpperCase();
  Turn.fromString(String s)
      : turn = s[0].toUpperCase(),
        halfTurn = s.length == 2 ? s[1] == "2" : false,
        inverted = s.length == 2 ? s[1] == "'" : false;

  @override
  int get hashCode => turn.hashCode + halfTurn.hashCode + inverted.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Turn &&
      turn == other.turn &&
      halfTurn == other.halfTurn &&
      inverted == other.inverted;

  Turn invert() {
    return Turn(turn, halfTurn: halfTurn, inverted: !inverted);
  }

  @override
  String toString() {
    return halfTurn ? "${turn}2" : (inverted ? "$turn'" : turn);
  }
}

class Turns {
  List<Turn> _turns;

  Turns(this._turns);
  Turns.fromString(String turns) : _turns = _fromString(turns);
  Turns.fromStrings(List<String> turns)
      : _turns = turns.map((s) => Turn.fromString(s)).toList();

  int get halfTurnMetric => _turns.length;

  List<Turn> get turns => _turns.toList();

  @override
  int get hashCode => _turns.hashCode;

  @override
  bool operator ==(Object other) =>
      other is Turns && listsEqual(_turns, other._turns);

  void add(Turn turn) {
    if (_turns.isNotEmpty) {
      Turn last = _turns.last;
      if (last.turn.toUpperCase() == turn.turn.toUpperCase()) {
        if (turn.halfTurn && last.halfTurn) {
          _turns.removeLast();
        } else if (turn.halfTurn && !last.halfTurn) {
          _turns.removeLast();
          _turns.add(last.invert());
        } else if (!turn.halfTurn && last.halfTurn) {
          _turns.removeLast();
          _turns.add(turn.invert());
        } else if (turn.inverted != last.inverted) {
          _turns.removeLast();
        } else {
          _turns.removeLast();
          _turns.add(Turn(turn.turn, halfTurn: true));
        }
      } else {
        _turns.add(turn);
      }
    } else {
      _turns.add(turn);
    }
  }

  void addTurns(Turns turns) {
    for (Turn turn in turns._turns) {
      add(turn);
    }
  }

  Turns copy() {
    return Turns(_turns.toList(growable: true));
  }

  void invert() {
    _turns = _turns.reversed.map((move) => move.invert()).toList();
  }

  void removeLastN(int n) {
    int startIndex = _turns.length - n;
    _turns.removeRange(startIndex >= 0 ? startIndex : 0, _turns.length);
  }

  @override
  String toString() {
    return _turns.map((e) => e.toString()).join();
  }

  static List<Turn> _fromString(String turns) {
    List<Turn> result = [];
    while (turns.isNotEmpty) {
      bool special = turns.length > 1 && (turns[1] == "2" || turns[1] == "'");
      int cutAtIndex = special ? 2 : 1;
      result.add(Turn.fromString(turns.substring(0, cutAtIndex)));
      turns = turns.substring(cutAtIndex);
    }
    return result;
  }
}
