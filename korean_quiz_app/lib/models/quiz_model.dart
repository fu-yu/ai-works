import 'package:freezed_annotation/freezed_annotation.dart';

part 'quiz_model.freezed.dart';
part 'quiz_model.g.dart';

@freezed
class Quiz with _$Quiz {
  const factory Quiz({
    required String question,
    required String correctAnswer,
    required List<String> options,
    String? explanation,
  }) = _Quiz;

  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
}

@freezed
class QuizSet with _$QuizSet {
  const factory QuizSet({
    required String title,
    required List<Quiz> quizzes,
    required int level,
  }) = _QuizSet;

  factory QuizSet.fromJson(Map<String, dynamic> json) =>
      _$QuizSetFromJson(json);
}
