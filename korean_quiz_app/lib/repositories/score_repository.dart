import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/score_model.dart';

abstract class IScoreRepository {
  Future<List<Score>> getScores();
  Future<void> saveScore(Score score);
  Future<void> clearScores();
  Future<void> saveStreak(int streak);
  Future<int> getStreak();
}

class ScoreRepository implements IScoreRepository {
  static const String _scoresKey = 'quiz_scores';
  static const String _streakKey = 'quiz_streak';
  final FlutterSecureStorage _storage;

  ScoreRepository({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  @override
  Future<List<Score>> getScores() async {
    try {
      final String? storedScores = await _storage.read(key: _scoresKey);
      if (storedScores == null) return [];

      final List<dynamic> jsonList = json.decode(storedScores);
      return jsonList.map((json) => Score.fromJson(json)).toList();
    } catch (e) {
      // エラー発生時は空のリストを返す
      await _storage.delete(key: _scoresKey);
      return [];
    }
  }

  @override
  Future<void> saveScore(Score score) async {
    try {
      final currentScores = await getScores();
      final updatedScores = [...currentScores, score];
      final String encodedScores = json.encode(
        updatedScores.map((s) => s.toJson()).toList(),
      );
      await _storage.write(key: _scoresKey, value: encodedScores);
    } catch (e) {
      rethrow; // 上位層でエラーハンドリング
    }
  }

  @override
  Future<void> clearScores() async {
    try {
      await _storage.delete(key: _scoresKey);
      await _storage.delete(key: _streakKey);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> saveStreak(int streak) async {
    try {
      await _storage.write(key: _streakKey, value: streak.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<int> getStreak() async {
    try {
      final String? streak = await _storage.read(key: _streakKey);
      return streak != null ? int.parse(streak) : 0;
    } catch (e) {
      await _storage.delete(key: _streakKey);
      return 0;
    }
  }
}
