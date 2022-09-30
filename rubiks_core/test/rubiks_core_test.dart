import 'dart:io';

import 'package:rubiks_core/rubiks_core.dart';
import 'package:test/test.dart';

void main() {
  group('A group of tests', () {
    final Cube cube = Cube.std();

    setUp(() {
      // Additional setup goes here.
    });

    test('First Test', () {
      /* Cube test = cube.turn(Turn("s")).turn(Turn("S")) */
      /* expect(.state, cube.std.state); */
    });
  });
}

class LocalLoader extends FileContentLoader {
  @override
  bool exists(String path) {
    File file = File(path);
    return file.existsSync();
  }

  @override
  Future<String> getFileContent(String path) {
    File file = File(path);
    return file.readAsString();
  }

  @override
  writeFileContent(String path, String content) {
    File file = File(path);
    file.writeAsStringSync(content, mode: FileMode.write, flush: true);
  }
}
