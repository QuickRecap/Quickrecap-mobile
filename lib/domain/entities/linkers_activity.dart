import 'linkers.dart';
import 'flashcard.dart';
import 'base_activity.dart';

class LinkersActivity extends BaseActivity{
  List<Flashcard>? flashcards;
  List<Linkers>? linkers;

  LinkersActivity({
    required this.flashcards,
    required this.linkers,
    required super.name,
    required super.id,
    required super.quantity,
    required super.timer,
    required super.isRated

  });

}