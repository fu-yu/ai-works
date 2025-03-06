import 'package:freezed_annotation/freezed_annotation.dart';

part 'score_model.freezed.dart';
part 'score_model.g.dart';

@freezed
class Score with _$Score {
  const Score._(); // Add this line to enable custom methods
  const factory Score({
    required int correctAnswers,
    required int totalQuestions,
    required DateTime timestamp,
    @Default(0) int streak,
  }) = _Score;

  double get percentage => (correctAnswers / totalQuestions) * 100;

  factory Score.fromJson(Map<String, dynamic> json) => _$ScoreFromJson(json);
}
