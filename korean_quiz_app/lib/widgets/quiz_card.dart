import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../models/quiz_model.dart';

class QuizCard extends StatefulWidget {
  final Quiz quiz;
  final Function(String) onAnswerSelected;
  final String? selectedAnswer;
  final bool showResult;

  const QuizCard({
    super.key,
    required this.quiz,
    required this.onAnswerSelected,
    this.selectedAnswer,
    this.showResult = false,
  });

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          margin: const EdgeInsets.all(16.0),
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.quiz.question,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                ...widget.quiz.options.map((option) {
                  final bool isSelected = option == widget.selectedAnswer;
                  final bool isCorrect = option == widget.quiz.correctAnswer;

                  Color? buttonColor;
                  if (widget.showResult) {
                    if (isCorrect) {
                      buttonColor = AppColors.correct;
                    } else if (isSelected && !isCorrect) {
                      buttonColor = AppColors.incorrect;
                    }
                  }

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    transform:
                        Matrix4.identity()..scale(isSelected ? 1.05 : 1.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed:
                          widget.showResult
                              ? null
                              : () => widget.onAnswerSelected(option),
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 18.0,
                          color:
                              widget.showResult && (isCorrect || isSelected)
                                  ? Colors.white
                                  : null,
                        ),
                      ),
                    ),
                  );
                }).toList(),
                if (widget.showResult && widget.quiz.explanation != null) ...[
                  const SizedBox(height: 16.0),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: widget.showResult ? 1.0 : 0.0,
                    child: Text(
                      widget.quiz.explanation!,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
