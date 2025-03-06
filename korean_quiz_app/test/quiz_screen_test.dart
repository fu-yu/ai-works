import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:korean_quiz_app/models/quiz_model.dart';
import 'package:korean_quiz_app/providers/quiz_provider.dart';
import 'package:korean_quiz_app/screens/quiz_screen.dart';
import 'package:korean_quiz_app/providers/score_provider.dart';
import 'package:mockito/mockito.dart';
import 'test_helper.mocks.dart';

void main() {
  group('QuizScreen Tests', () {
    late QuizSet quizSet;
    late MockIScoreRepository mockRepository;

    setUp(() {
      quizSet = QuizSet(
        title: 'Test Quiz',
        quizzes: [
          Quiz(
            question: '質問1',
            correctAnswer: '正解1',
            options: ['正解1', '不正解1', '不正解2'],
          ),
          Quiz(
            question: '質問2',
            correctAnswer: '正解2',
            options: ['正解2', '不正解3', '不正解4'],
          ),
        ],
        level: 1,
      );

      mockRepository = MockIScoreRepository();
      when(mockRepository.getScores()).thenAnswer((_) async => []);
      when(mockRepository.getStreak()).thenAnswer((_) async => 0);
    });

    Future<void> pumpQuizScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => QuizProvider()),
            ChangeNotifierProvider(
              create: (_) => ScoreProvider(repository: mockRepository),
            ),
          ],
          child: MaterialApp(home: QuizScreen(quizSet: quizSet)),
        ),
      );
      // 初期化を待つ
      await tester.pumpAndSettle();
    }

    testWidgets('should display quiz and handle answers correctly', (
      WidgetTester tester,
    ) async {
      await pumpQuizScreen(tester);

      // 初期表示の確認
      expect(find.text('質問1'), findsOneWidget);
      expect(find.text('正解1'), findsOneWidget);
      expect(find.text('不正解1'), findsOneWidget);
      expect(find.text('不正解2'), findsOneWidget);

      // 回答選択
      await tester.tap(find.text('正解1'));
      await tester.pump();

      // 確認ボタンを探して押す
      final button = find.byKey(const Key('quiz_action_button'));
      expect(button, findsOneWidget);
      await tester.tap(button);
      await tester.pump();

      // 次の問題へ
      await tester.tap(button);
      await tester.pump();

      // 2問目の表示確認
      expect(find.text('質問2'), findsOneWidget);
      expect(find.text('正解2'), findsOneWidget);
    });

    testWidgets('should show progress indicator', (WidgetTester tester) async {
      await pumpQuizScreen(tester);

      // プログレスインジケーターの確認
      final progressIndicator = find.byType(LinearProgressIndicator);
      expect(progressIndicator, findsOneWidget);

      final indicator = tester.widget<LinearProgressIndicator>(
        progressIndicator,
      );
      expect(indicator.value, 0.5); // 2問中1問目なので0.5
    });

    testWidgets('should complete quiz and show result', (
      WidgetTester tester,
    ) async {
      // スコア保存のモック
      when(mockRepository.saveScore(any)).thenAnswer((_) async {});
      when(mockRepository.saveStreak(any)).thenAnswer((_) async {});

      await pumpQuizScreen(tester);

      // 1問目回答
      await tester.tap(find.text('正解1'));
      await tester.pump();
      final actionButton = find.byKey(const Key('quiz_action_button'));
      await tester.tap(actionButton);
      await tester.pump();
      await tester.tap(actionButton);
      await tester.pump();

      // 2問目回答
      await tester.tap(find.text('正解2'));
      await tester.pump();
      await tester.tap(actionButton);
      await tester.pump();

      // 結果画面へ
      await tester.tap(actionButton);
      await tester.pumpAndSettle();

      // 結果の確認
      expect(find.text('2/2問 正解！'), findsOneWidget);
      expect(find.text('正答率: 100.0%'), findsOneWidget);

      // スコアの保存確認
      verify(mockRepository.saveScore(any)).called(1);
    });
  });
}
