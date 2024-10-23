import 'linkers.dart';
import 'flashcard.dart';

class LinkersActivity{
  List<Flashcard>? flashcards;
  List<Linkers>? linkers;
  int id;
  String name;
  int quantity;
  int timer;
  bool isRated;

  LinkersActivity({
    required this.id,
    required this.flashcards,
    required this.linkers,
    required this.name,
    required this.quantity,
    required this.timer,
    required this.isRated

  });


}