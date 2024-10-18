import 'gaps.dart';
import 'flashcard.dart';

class GapsActivity {
  List<Flashcard>? flashcards;
  List<Gaps>? gaps;
  int id;
  String name;
  int quantity;
  int timer;
  bool isRated;

  GapsActivity({
    required this.id,
    required this.flashcards,
    required this.gaps,
    required this.name,
    required this.quantity,
    required this.timer,
    required this.isRated

  });
}
