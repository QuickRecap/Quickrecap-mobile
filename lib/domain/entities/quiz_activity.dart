
import 'quiz.dart';
import 'flashcard.dart';

class QuizActivity {
  List<Flashcard>? flashcards;
  List<Quiz>? quizzes;
  String name;
  int quantity;
  int timer;

  QuizActivity({
    required this.flashcards,
    required this.quizzes,
    required this.name,
    required this.quantity,
    required this.timer,

  });
}
