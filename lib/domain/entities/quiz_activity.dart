import 'quiz.dart';
import 'flashcard.dart';

class QuizActivity {
  List<Flashcard>? flashcards;
  List<Quiz>? quizzes;
  int id;
  String name;
  int quantity;
  int timer;
  bool isRated;

  QuizActivity({
    required this.id,
    required this.flashcards,
    required this.quizzes,
    required this.name,
    required this.quantity,
    required this.timer,
    required this.isRated

  });
}
