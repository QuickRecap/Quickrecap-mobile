class ActivityReview {
  final int activityId;
  final String activityType;
  final int totalSeconds;
  final int score;
  final int questions;
  final int correctAnswers;

  ActivityReview({
    required this.activityId,
    required this.activityType,
    required this.totalSeconds,
    required this.score,
    required this.questions,
    required this.correctAnswers,
  });

}
