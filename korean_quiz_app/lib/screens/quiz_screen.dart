import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../models/score_model.dart';
import '../utils/constants.dart';
import '../widgets/quiz_card.dart';
import '../providers/quiz_provider.dart';
import '../providers/score_provider.dart';

class QuizScreen extends StatelessWidget {
  final QuizSet quizSet;

  const QuizScreen({super.key, required this.quizSet});

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);

    // buildメソッドでの状態変更を遅延実行
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (quizProvider.currentQuizSet != quizSet) {
        quizProvider.startQuiz(quizSet);
      }
    });

    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(quizSet.title),
          backgroundColor: AppColors.primary,
        ),
        body: Consumer<QuizProvider>(
          builder: (context, provider, child) {
            final currentQuiz = provider.currentQuiz;
            if (currentQuiz == null) return const SizedBox.shrink();

            return Column(
              children: [
                LinearProgressIndicator(
                  value:
                      (provider.currentQuestionIndex + 1) /
                      quizSet.quizzes.length,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.secondary,
                  ),
                ),
                Expanded(
                  child: Hero(
                    tag:
                        'quiz_card_${quizSet.title}_${provider.currentQuestionIndex}',
                    child: Material(
                      type: MaterialType.transparency,
                      child: QuizCard(
                        quiz: currentQuiz,
                        onAnswerSelected: provider.selectAnswer,
                        selectedAnswer: provider.selectedAnswer,
                        showResult: provider.showResult,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    key: const Key('quiz_action_button'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed:
                        provider.selectedAnswer == null
                            ? null
                            : provider.showResult
                            ? () => _handleNextQuestion(context, provider)
                            : provider.checkAnswer,
                    child: Text(
                      provider.showResult
                          ? provider.isLastQuestion
                              ? Strings.result
                              : Strings.nextQuestion
                          : Strings.checkAnswer,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleNextQuestion(BuildContext context, QuizProvider provider) {
    if (provider.isLastQuestion) {
      final score = Score(
        correctAnswers: provider.correctAnswers,
        totalQuestions: quizSet.quizzes.length,
        timestamp: DateTime.now(),
      );

      context.read<ScoreProvider>().addScore(score);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) {
            return FadeTransition(
              opacity: animation,
              child: _ResultScreen(score: score),
            );
          },
        ),
      );
    } else {
      provider.nextQuestion();
    }
  }
}

class _ResultScreen extends StatelessWidget {
  final Score score;

  const _ResultScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return AnimatedTheme(
      duration: const Duration(milliseconds: 300),
      data: Theme.of(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.result),
          backgroundColor: AppColors.primary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${score.correctAnswers}/${score.totalQuestions}問 正解！',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '正答率: ${score.percentage.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                key: const Key('back_to_home_button'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(Strings.back, style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
