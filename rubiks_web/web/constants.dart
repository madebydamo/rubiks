import 'dart:core';

List<int> translateX = [ -1, -1, -1, 0, 0, 0, 1, 1, 1, -1, -1, -1, 0, 0, 1, 1, 1, -1, -1, -1, 0, 0, 0, 1, 1, 1 ];
List<int> translateY = [ -1, -1, -1, -1, -1, -1, -1, -1, -1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1 ];
List<int> translateZ = [ -1, 0, 1, -1, 0, 1, -1, 0, 1, -1, 0, 1, -1, 1, -1, 0, 1, -1, 0, 1, -1, 0, 1, -1, 0, 1 ];

Map<String, List<int>> translate = {
  "X": translateX,
  "Y": translateY,
  "Z": translateZ
};
Map<String, String> colors = {
  "w": "white",
  "r": "red",
  "o": "orange",
  "y": "yellow",
  "g": "green",
  "b": "blue"
};
List<int> indexToPiece = [ 0, 3, 6, 7, 8, 5, 2, 1, 0, 1, 2, 11, 19, 18, 17, 9, 2, 5, 8, 16, 25, 22, 19, 11, 8, 7, 6, 14, 23, 24, 25, 16, 6, 3, 0, 9, 17, 20, 23, 14, 19, 22, 25, 24, 23, 20, 17, 18, 4, 10, 13, 15, 12, 21 ];
List<int> indexToChildIndex = [ 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 5, 5, 5, 5, 5, 5, 1, 1, 1, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 2, 0, 5, 1, 4, 3 ];
Map<String, String> turnToAxis = {
  "r": "X",
  "l": "X",
  "m": "X",
  "x": "X",
  "f": "Z",
  "b": "Z",
  "s": "Z",
  "z": "Z",
  "u": "Y",
  "d": "Y",
  "e": "Y",
  "y": "Y"
};
Map<String, List<int>> turnToLayer = {
  "r": [1],
  "l": [-1],
  "m": [0],
  "x": [-1, 0, 1],
  "f": [1],
  "b": [-1],
  "s": [0],
  "z": [-1, 0, 1],
  "u": [-1],
  "d": [1],
  "e": [0],
  "y": [-1, 0, 1]
};
Map<String, bool> invertDirection = {
  "r": false,
  "l": true,
  "m": true,
  "x": false,
  "f": false,
  "b": true,
  "s": false,
  "z": false,
  "u": true,
  "d": false,
  "e": false,
  "y": true
};
Map<String, List<List<int>>> turnToStickerCycle = _turnToStickerCycle();

Map<String, List<List<int>>> _turnToStickerCycle() {
  Map<String, List<List<int>>> tempMap = {
    "r": [
      [5, 33, 45, 21],
      [4, 40, 44, 20],
      [3, 39, 43, 19],
      [25, 27, 29, 31],
      [26, 28, 30, 32]
    ],
    "l": [
      [1, 17, 41, 37],
      [8, 24, 48, 36],
      [7, 23, 47, 35],
      [9, 11, 13, 15],
      [10, 12, 14, 16]
    ],
    "m": [
      [2, 18, 42, 38],
      [49, 51, 54, 53],
      [6, 22, 46, 34]
    ],
    "d": [
      [15, 23, 31, 39],
      [14, 22, 30, 38],
      [13, 21, 29, 37],
      [41, 43, 45, 47],
      [42, 44, 46, 48]
    ],
    "u": [
      [33, 25, 17, 9],
      [34, 26, 18, 10],
      [35, 27, 19, 11],
      [1, 3, 5, 7],
      [2, 4, 6, 8]
    ],
    "e": [
      [16, 24, 32, 40],
      [50, 51, 52, 53],
      [12, 20, 28, 36]
    ],
    "f": [
      [43, 13, 7, 25],
      [42, 12, 6, 32],
      [41, 11, 5, 31],
      [17, 19, 21, 23],
      [18, 20, 22, 24]
    ],
    "b": [
      [15, 45, 27, 1],
      [16, 46, 28, 2],
      [9, 47, 29, 3],
      [33, 35, 37, 39],
      [34, 36, 38, 40]
    ],
    "s": [
      [4, 30, 48, 10],
      [49, 52, 54, 50],
      [8, 26, 44, 14]
    ],
  };

  List<List<int>> reverse(List<List<int>> list) {
    List<List<int>> temp = List.empty(growable: true);
    for (var element in list) {
      temp.add(element.reversed.toList());
    }
    return temp;
  }

  tempMap.putIfAbsent("x", () {
    List<List<int>> temp = List.empty(growable: true);
    List<List<int>>? r = tempMap["r"];
    List<List<int>>? l = tempMap["l"];
    List<List<int>>? m = tempMap["m"];
    if (r != null && l != null && m != null) {
      temp.addAll(r);
      temp.addAll(reverse(l));
      temp.addAll(reverse(m));
    }
    return temp;
  });
  tempMap.putIfAbsent("y", () {
    List<List<int>> temp = List.empty(growable: true);
    List<List<int>>? u = tempMap["u"];
    List<List<int>>? d = tempMap["d"];
    List<List<int>>? e = tempMap["e"];
    if (u != null && d != null && e != null) {
      temp.addAll(u);
      temp.addAll(reverse(d));
      temp.addAll(reverse(e));
    }
    return temp;
  });
  tempMap.putIfAbsent("z", () {
    List<List<int>> temp = List.empty(growable: true);
    List<List<int>>? f = tempMap["f"];
    List<List<int>>? b = tempMap["b"];
    List<List<int>>? s = tempMap["s"];
    if (f != null && b != null && s != null) {
      temp.addAll(f);
      temp.addAll(reverse(b));
      temp.addAll(s);
    }
    return temp;
  });

  return tempMap;
}

List<List<int>> edges = [[6, 18], [4, 26], [2, 34], [8, 10], [16, 36], [12, 24], [20, 32], [28, 40], [22, 42], [44, 30], [46, 38], [48, 14]];
List<List<int>> corners = [[7, 11, 17], [19, 5, 25], [27, 33, 3], [35, 9, 1], [13, 23, 41], [21, 31, 43], [15, 47, 37], [45, 29, 39]];
