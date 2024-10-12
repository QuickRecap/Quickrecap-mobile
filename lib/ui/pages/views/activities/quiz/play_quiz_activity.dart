import 'package:flutter/material.dart';
import '../flashcards/play_flashcards.dart'; // Importa tu archivo PlayFlashcards
import '../../../../../domain/entities/flashcard.dart';
import '../../../../../domain/entities/flashcard_activity.dart'; // Importa tus entidades
import '../../../../../domain/entities/quiz_activity.dart'; // Importa tu entidad QuizActivity
import 'play_quiz.dart'; // Importa tu archivo PlayQuiz

class PlayQuizActivity extends StatefulWidget {
  final QuizActivity quizActivity; // Recibe QuizActivity

  PlayQuizActivity({required this.quizActivity});

  @override
  _PlayQuizActivityState createState() => _PlayQuizActivityState();
}

class _PlayQuizActivityState extends State<PlayQuizActivity> {
  bool _isPreparationCompleted = false;

  @override
  Widget build(BuildContext context) {
    if (!_isPreparationCompleted) {
      // Extraemos las propiedades del quizActivity
      List<Flashcard>? flashcards = widget.quizActivity.flashcards;
      String? name = widget.quizActivity.name;
      int id = widget.quizActivity.id;
      int? quantity = widget.quizActivity.quantity;
      int? timer = widget.quizActivity.timer;

      // Crear una nueva instancia de FlashcardActivity
      FlashcardActivity flashcardActivity = FlashcardActivity(
        id: id,
        flashcards: flashcards,
        name: name,
        quantity: quantity,
        timer: timer,
      );

      // Mostrar la fase de preparación usando PlayFlashcards
      return PlayFlashcards(
        flashcardActivity: flashcardActivity, // Pasamos FlashcardActivity
        isPreparation: true, // Indicar que es una fase de preparación
        onPreparationComplete: completePreparation, // Callback para completar la preparación
      );
    } else {
      // Mostrar la actividad de quiz después de la preparación
      return PlayQuiz(quizActivity: widget.quizActivity); // Renderiza PlayQuiz
    }
  }

  void completePreparation() {
    setState(() {
      _isPreparationCompleted = true; // Cambia el estado para mostrar el quiz
    });
  }
}
