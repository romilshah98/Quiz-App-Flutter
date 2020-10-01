import 'dart:io';

import 'package:path_provider/path_provider.dart';

class ScoreStorage {
  Future<String> getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile() async {
    final path = await getLocalPath();
    return File('$path/quiz_score.txt');
  }

  Future<int> readScore() async {
    try {
      final file = await getLocalFile();
      final String score = await file.readAsString();
      return int.parse(score);
    } catch (e) {
      return -1;
    }
  }

  Future<File> writeScore(int score) async {
    final file = await getLocalFile();
    return file.writeAsString('$score');
  }
}
