import 'flashcard.dart';

class FlashcardActivity {
  List<Flashcard>? flashcards;
  String name;
  int quantity;
  int timer;
  int id;

  FlashcardActivity({
    required this.flashcards,
    required this.name,
    required this.id,
    required this.quantity,
    required this.timer,

  });
}
