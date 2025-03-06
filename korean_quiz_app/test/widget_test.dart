import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:korean_quiz_app/main.dart';
import 'package:korean_quiz_app/providers/score_provider.dart';
import 'package:korean_quiz_app/providers/quiz_provider.dart';
import 'package:korean_quiz_app/models/quiz_model.dart';
import 'package:korean_quiz_app/models/score_model.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

void main() {
  group('Korean Quiz App Tests', () {
    testWidgets('App smoke test', (WidgetTester tester) async {
      final mockRepository = MockIScoreRepository();
      when(mockRepository.getScores()).thenAnswer((_) async => []);
      when(mockRepository.getStreak()).thenAnswer((_) async => 0);

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => QuizProvider()),
            ChangeNotifierProvider(
              create: (_) => ScoreProvider(repository: mockRepository),
            ),
          ],
          child: const KoreanQuizApp(),
        ),
      );
      expect(find.text('韓国語クイズ'), findsOneWidget);
    });

    test('Score model test', () {
      final score = Score(
        correctAnswers: 8,
        totalQuestions: 10,
        timestamp: DateTime.now(),
      );
      expect(score.correctAnswers, 8);
      expect(score.totalQuestions, 10);
      expect(score.percentage, 80.0);
    });

    test('Quiz model test', () {
      final quiz = Quiz(
        question: 'Test Question',
        correctAnswer: 'Correct',
        options: ['Wrong', 'Correct', 'Also Wrong'],
      );
      expect(quiz.question, 'Test Question');
      expect(quiz.correctAnswer, 'Correct');
      expect(quiz.options.length, 3);
    });
  });
}
