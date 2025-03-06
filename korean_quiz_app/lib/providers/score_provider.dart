import 'package:flutter/foundation.dart';
import 'package:korean_quiz_app/models/score_model.dart';
import 'package:korean_quiz_app/repositories/score_repository.dart';

class ScoreProvider extends ChangeNotifier {
  final IScoreRepository repository;
  List<Score> _scores = [];
  int _currentStreak = 0;

  ScoreProvider({required this.repository}) {
    _loadInitialData();
  }

  List<Score> get scores => _scores;
  int get currentStreak => _currentStreak;

  Future<void> _loadInitialData() async {
    await loadScores();
    await loadStreak();
  }

  Future<void> loadScores() async {
    _scores = await repository.getScores();
    notifyListeners();
  }

  Future<void> loadStreak() async {
    _currentStreak = await repository.getStreak();
    notifyListeners();
  }

  Future<void> addScore(Score score) async {
    await repository.saveScore(score);
    await loadScores();
  }

  Future<void> updateStreak(int streak) async {
    await repository.saveStreak(streak);
    _currentStreak = streak;
    notifyListeners();
  }

  Future<void> clearAllData() async {
    await repository.clearScores();
    _scores = [];
    _currentStreak = 0;
    notifyListeners();
  }
}
