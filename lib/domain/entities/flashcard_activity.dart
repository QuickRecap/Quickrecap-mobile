import 'flashcard.dart';
import 'base_activity.dart';

class FlashcardActivity extends BaseActivity{
  List<Flashcard>? flashcards;

  FlashcardActivity({
    required this.flashcards,
    required super.name,
    required super.id,
    required super.quantity,
    required super.timer,
    required super.isRated

  });
}
