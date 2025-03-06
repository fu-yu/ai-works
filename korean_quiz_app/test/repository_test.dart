import 'package:flutter_test/flutter_test.dart';
import 'package:korean_quiz_app/models/score_model.dart';
import 'package:korean_quiz_app/repositories/score_repository.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

void main() {
  group('ScoreRepository Tests', () {
    late MockFlutterSecureStorage mockStorage;
    late ScoreRepository repository;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      repository = ScoreRepository(storage: mockStorage);
    });

    test('should save and load scores correctly', () async {
      final score = Score(
        correctAnswers: 8,
        totalQuestions: 10,
        timestamp: DateTime.now(),
      );

      // セーブのテスト
      when(
        mockStorage.write(key: 'quiz_scores', value: anyNamed('value')),
      ).thenAnswer((_) async {});

      await repository.saveScore(score);
      verify(
        mockStorage.write(key: 'quiz_scores', value: anyNamed('value')),
      ).called(1);

      // ロードのテスト
      final jsonString =
          '[{"correctAnswers":8,"totalQuestions":10,"timestamp":"2025-03-05T06:00:00.000Z"}]';
      when(
        mockStorage.read(key: 'quiz_scores'),
      ).thenAnswer((_) async => jsonString);

      final scores = await repository.getScores();
      expect(scores.length, 1);
      expect(scores[0].correctAnswers, 8);
      expect(scores[0].totalQuestions, 10);
    });

    test('should manage streak correctly', () async {
      // ストリークの保存テスト
      when(
        mockStorage.write(key: 'quiz_streak', value: '5'),
      ).thenAnswer((_) async {});

      await repository.saveStreak(5);
      verify(mockStorage.write(key: 'quiz_streak', value: '5')).called(1);

      // ストリークの読み込みテスト
      when(mockStorage.read(key: 'quiz_streak')).thenAnswer((_) async => '5');

      final streak = await repository.getStreak();
      expect(streak, 5);
    });

    test('should clear all data correctly', () async {
      when(mockStorage.delete(key: anyNamed('key'))).thenAnswer((_) async {});

      await repository.clearScores();
      verify(mockStorage.delete(key: 'quiz_scores')).called(1);
      verify(mockStorage.delete(key: 'quiz_streak')).called(1);
    });

    test('should handle corrupted data gracefully', () async {
      when(
        mockStorage.read(key: 'quiz_scores'),
      ).thenAnswer((_) async => '{invalid json}');

      final scores = await repository.getScores();
      expect(scores, isEmpty);
    });
  });
}
