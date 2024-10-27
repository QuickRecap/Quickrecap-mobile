import 'package:flutter/material.dart';
import '../flashcards/play_flashcards.dart'; // Importa tu archivo PlayFlashcards
import '../../../../../domain/entities/flashcard.dart';
import '../../../../../domain/entities/flashcard_activity.dart'; // Importa tus entidades
import '../../../../../domain/entities/linkers_activity.dart'; // Importa tu entidad QuizActivity
import 'play_linkers.dart'; // Importa tu archivo PlayQuiz

class PlayLinkersActivity extends StatefulWidget {
  final LinkersActivity linkersActivity; // Recibe QuizActivity

  PlayLinkersActivity({required this.linkersActivity});

  @override
  _PlayLinkersActivityState createState() => _PlayLinkersActivityState();
}

class _PlayLinkersActivityState extends State<PlayLinkersActivity> {
  bool _isPreparationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (!_isPreparationCompleted) {
      // Extraemos las propiedades del quizActivity
      List<Flashcard>? flashcards = widget.linkersActivity.flashcards;
      String? name = widget.linkersActivity.name;
      int id = widget.linkersActivity.id;
      int? quantity = widget.linkersActivity.quantity;
      int? timer = widget.linkersActivity.timer;

      // Crear una nueva instancia de FlashcardActivity
      FlashcardActivity flashcardActivity = FlashcardActivity(
          id: id,
          flashcards: flashcards,
          name: name,
          quantity: quantity,
          timer: timer,
          isRated: false
      );

      // Mostrar la fase de preparación usando PlayFlashcards
      return PlayFlashcards(
        flashcardActivity: flashcardActivity, // Pasamos FlashcardActivity
        isPreparation: true, // Indicar que es una fase de preparación
        onPreparationComplete: completePreparation, // Callback para completar la preparación
      );
    } else {
      // Mostrar la actividad de quiz después de la preparación
      return PlayLinkers(linkersActivity: widget.linkersActivity); // Renderiza PlayQuiz
    }
  }

  void completePreparation() {
    setState(() {
      _isPreparationCompleted = true; // Cambia el estado para mostrar el quiz
    });
  }
}
