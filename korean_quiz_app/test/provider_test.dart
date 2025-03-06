import 'package:flutter_test/flutter_test.dart';
import 'package:korean_quiz_app/models/quiz_model.dart';
import 'package:korean_quiz_app/models/score_model.dart';
import 'package:korean_quiz_app/providers/quiz_provider.dart';
import 'package:korean_quiz_app/providers/score_provider.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

void main() {
  group('Provider Tests', () {
    test('Quiz Provider test', () {
      final provider = QuizProvider();
      final quizSet = QuizSet(
        title: 'Test Quiz',
        quizzes: [
          Quiz(
            question: 'Q1',
            correctAnswer: 'A1',
            options: ['A1', 'B1', 'C1'],
          ),
          Quiz(
            question: 'Q2',
            correctAnswer: 'A2',
            options: ['A2', 'B2', 'C2'],
          ),
        ],
        level: 1,
      );

      // 初期状態をテスト
      expect(provider.currentQuizSet, null);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.selectedAnswer, null);
      expect(provider.showResult, false);
      expect(provider.correctAnswers, 0);
      expect(provider.isLastQuestion, false);
      expect(provider.currentQuiz, null);

      // クイズ開始をテスト
      provider.startQuiz(quizSet);
      expect(provider.currentQuizSet, quizSet);
      expect(provider.currentQuestionIndex, 0);
      expect(provider.selectedAnswer, null);
      expect(provider.showResult, false);
      expect(provider.correctAnswers, 0);
      expect(provider.isLastQuestion, false);
      expect(provider.currentQuiz, quizSet.quizzes[0]);

      // 回答選択をテスト
      provider.selectAnswer('A1');
      expect(provider.selectedAnswer, 'A1');

      // 正解チェックをテスト
      provider.checkAnswer();
      expect(provider.showResult, true);
      expect(provider.correctAnswers, 1);

      // 次の問題へ
      provider.nextQuestion();
      expect(provider.currentQuestionIndex, 1);
      expect(provider.selectedAnswer, null);
      expect(provider.showResult, false);
      expect(provider.isLastQuestion, true);
    });

    test('Score Provider test', () async {
      final mockRepository = MockIScoreRepository();
      when(mockRepository.getScores()).thenAnswer((_) async => []);
      when(mockRepository.getStreak()).thenAnswer((_) async => 0);
      final provider = ScoreProvider(repository: mockRepository);

      await provider.loadScores(); // 明示的にロード
      expect(provider.scores, isEmpty);
      expect(provider.currentStreak, 0);

      // スコアの追加をテスト
      final score = Score(
        correctAnswers: 8,
        totalQuestions: 10,
        timestamp: DateTime.now(),
      );
      when(mockRepository.saveScore(any)).thenAnswer((_) async {});
      await provider.addScore(score);

      verify(mockRepository.saveScore(score)).called(1);

      // ストリークの更新をテスト
      when(mockRepository.saveStreak(3)).thenAnswer((_) async {});
      await provider.updateStreak(3);
      expect(provider.currentStreak, 3);
      verify(mockRepository.saveStreak(3)).called(1);
    });
  });
}
