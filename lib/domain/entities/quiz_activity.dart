import 'quiz.dart';
import 'flashcard.dart';
import 'base_activity.dart';

class QuizActivity extends BaseActivity {
  List<Flashcard>? flashcards;
  List<Quiz>? quizzes;

  QuizActivity({
    required this.flashcards,
    required this.quizzes,
    required super.name,
    required super.id,
    required super.quantity,
    required super.timer,
    required super.isRated

  });
}
