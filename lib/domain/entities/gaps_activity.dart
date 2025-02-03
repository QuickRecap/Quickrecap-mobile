import 'gaps.dart';
import 'flashcard.dart';
import 'base_activity.dart';

class GapsActivity extends BaseActivity {
  List<Flashcard>? flashcards;
  List<Gaps>? gaps;

  GapsActivity({
    required this.flashcards,
    required this.gaps,
    required super.name,
    required super.id,
    required super.quantity,
    required super.timer,
    required super.isRated

  });
}
