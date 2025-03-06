import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/quiz_model.dart';
import '../utils/constants.dart';
import '../providers/score_provider.dart';
import 'quiz_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startQuiz(BuildContext context, QuizSet quizSet) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return FadeTransition(
            opacity: animation,
            child: QuizScreen(quizSet: quizSet),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scoreProvider = Provider.of<ScoreProvider>(context);
    final streak = scoreProvider.currentStreak;

    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.appTitle),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          if (streak > 0)
            SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: _controller, curve: Curves.easeOut),
              ),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                color: AppColors.secondary.withAlpha(25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(begin: 0.5, end: 1.0),
                      duration: const Duration(milliseconds: 500),
                      builder: (context, value, child) {
                        return Transform.scale(scale: value, child: child);
                      },
                      child: const Icon(
                        Icons.local_fire_department,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$streak日連続学習中！',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: sampleQuizSets.length,
              itemBuilder: (context, index) {
                final quizSet = sampleQuizSets[index];
                final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      index * 0.1,
                      index * 0.1 + 0.5,
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.5, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: Hero(
                      tag: 'quiz_card_${quizSet.title}_start',
                      child: Material(
                        type: MaterialType.transparency,
                        child: Card(
                          elevation: 2.0,
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 1.0, end: 1.0),
                            duration: const Duration(milliseconds: 200),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: InkWell(
                              onTap: () => _startQuiz(context, quizSet),
                              onHover: (hover) {
                                if (hover) {
                                  (context as Element).markNeedsBuild();
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quizSet.title,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'レベル ${quizSet.level} • ${quizSet.quizzes.length}問',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
