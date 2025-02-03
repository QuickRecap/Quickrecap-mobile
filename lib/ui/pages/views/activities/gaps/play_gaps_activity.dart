import 'package:flutter/material.dart';
import '../flashcards/play_flashcards.dart'; // Importa tu archivo PlayFlashcards
import '../../../../../domain/entities/flashcard.dart';
import '../../../../../domain/entities/flashcard_activity.dart'; // Importa tus entidades
import '../../../../../domain/entities/gaps_activity.dart'; // Importa tu entidad QuizActivity
import 'play_gaps.dart'; // Importa tu archivo PlayQuiz

class PlayGapsActivity extends StatefulWidget {
  final GapsActivity gapsActivity; // Recibe QuizActivity

  PlayGapsActivity({required this.gapsActivity});

  @override
  _PlayGapsActivityState createState() => _PlayGapsActivityState();
}

class _PlayGapsActivityState extends State<PlayGapsActivity> {
  bool _isPreparationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (!_isPreparationCompleted) {
      // Extraemos las propiedades del quizActivity
      List<Flashcard>? flashcards = widget.gapsActivity.flashcards;
      String? name = widget.gapsActivity.name;
      int id = widget.gapsActivity.id;
      int? quantity = widget.gapsActivity.quantity;
      int? timer = widget.gapsActivity.timer;

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
      return PlayGaps(gapsActivity: widget.gapsActivity); // Renderiza PlayQuiz
    }
  }

  void completePreparation() {
    setState(() {
      _isPreparationCompleted = true; // Cambia el estado para mostrar el quiz
    });
  }
}
