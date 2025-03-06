import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:korean_quiz_app/models/quiz_model.dart';
import 'package:korean_quiz_app/providers/quiz_provider.dart';
import 'package:korean_quiz_app/providers/score_provider.dart';
import 'package:korean_quiz_app/repositories/score_repository.dart';
import 'package:korean_quiz_app/screens/quiz_screen.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

void main() {
  group('Integration Tests', () {
    late MockFlutterSecureStorage mockStorage;
    late ScoreRepository repository;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      mockStorage = MockFlutterSecureStorage();
      repository = ScoreRepository(storage: mockStorage);
    });

    Future<void> pumpQuizScreen(WidgetTester tester) async {
      final quizSet = QuizSet(
        title: 'Test Quiz',
        quizzes: [
          Quiz(
            question: 'Question 1',
            correctAnswer: 'Correct',
            options: ['Correct', 'Wrong1', 'Wrong2'],
          ),
        ],
        level: 1,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => QuizProvider()),
            ChangeNotifierProvider(
              create: (_) => ScoreProvider(repository: repository),
            ),
          ],
          child: MaterialApp(home: QuizScreen(quizSet: quizSet)),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('should handle full quiz flow', (WidgetTester tester) async {
      // モックの設定
      when(mockStorage.read(key: 'quiz_scores')).thenAnswer((_) async => '[]');
      when(
        mockStorage.write(key: 'quiz_scores', value: anyNamed('value')),
      ).thenAnswer((_) async {});
      when(mockStorage.read(key: 'quiz_streak')).thenAnswer((_) async => '0');

      // クイズ画面の表示
      await pumpQuizScreen(tester);

      // 選択肢をタップ
      await tester.tap(find.text('Correct'));
      await tester.pumpAndSettle();

      // 確認ボタンをタップ
      final button = find.byKey(const Key('quiz_action_button'));
      await tester.tap(button);
      await tester.pumpAndSettle();

      // 結果ボタンをタップ
      await tester.tap(button);
      await tester.pumpAndSettle();

      // 戻るボタンをタップ
      await tester.tap(find.byKey(const Key('back_to_home_button')));
      await tester.pumpAndSettle();

      // スコア保存の確認
      verify(
        mockStorage.write(key: 'quiz_scores', value: anyNamed('value')),
      ).called(1);
    });

    testWidgets('should handle storage errors gracefully', (
      WidgetTester tester,
    ) async {
      // ストレージエラーの設定
      when(
        mockStorage.read(key: 'quiz_scores'),
      ).thenThrow(Exception('Storage error'));

      await pumpQuizScreen(tester);
      await tester.pumpAndSettle();

      // エラー時も正常に動作することを確認
      expect(find.text('Question 1'), findsOneWidget);
    });
  });
}
