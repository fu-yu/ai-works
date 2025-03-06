import 'package:flutter/material.dart';
import '../models/quiz_model.dart';

class QuizProvider with ChangeNotifier {
  QuizSet? _currentQuizSet;
  int _currentQuestionIndex = 0;
  String? _selectedAnswer;
  bool _showResult = false;
  int _correctAnswers = 0;

  QuizSet? get currentQuizSet => _currentQuizSet;
  int get currentQuestionIndex => _currentQuestionIndex;
  String? get selectedAnswer => _selectedAnswer;
  bool get showResult => _showResult;
  int get correctAnswers => _correctAnswers;
  bool get isLastQuestion =>
      _currentQuizSet != null &&
      _currentQuestionIndex == _currentQuizSet!.quizzes.length - 1;

  Quiz? get currentQuiz =>
      _currentQuizSet != null
          ? _currentQuizSet!.quizzes[_currentQuestionIndex]
          : null;

  void startQuiz(QuizSet quizSet) {
    _currentQuizSet = quizSet;
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _showResult = false;
    _correctAnswers = 0;
    notifyListeners();
  }

  void selectAnswer(String answer) {
    _selectedAnswer = answer;
    notifyListeners();
  }

  void checkAnswer() {
    if (_selectedAnswer != null && currentQuiz != null) {
      _showResult = true;
      if (_selectedAnswer == currentQuiz!.correctAnswer) {
        _correctAnswers++;
      }
      notifyListeners();
    }
  }

  void nextQuestion() {
    if (_currentQuizSet != null && !isLastQuestion) {
      _currentQuestionIndex++;
      _selectedAnswer = null;
      _showResult = false;
      notifyListeners();
    }
  }

  void reset() {
    _currentQuizSet = null;
    _currentQuestionIndex = 0;
    _selectedAnswer = null;
    _showResult = false;
    _correctAnswers = 0;
    notifyListeners();
  }
}
