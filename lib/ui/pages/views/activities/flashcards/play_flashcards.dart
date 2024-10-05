import 'package:flutter/material.dart';
import '../../../../../domain/entities/flashcard.dart';
import '../../../../../domain/entities/flashcard_activity.dart'; // Importa la clase FlashcardActivity

class PlayFlashcards extends StatefulWidget {
  final FlashcardActivity flashcardActivity;

  PlayFlashcards({required this.flashcardActivity});

  @override
  _PlayFlashcardsState createState() => _PlayFlashcardsState();
}

class _PlayFlashcardsState extends State<PlayFlashcards> {
  int _currentIndex = 0;
  bool _showDefinition = false;
  late int _remainingTime;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.flashcardActivity.timer;
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_remainingTime > 0 && mounted) {
        setState(() {
          _remainingTime--;
        });
        _startTimer(); // Llamar nuevamente para seguir reduciendo el tiempo
      }
    });
  }

  void _nextFlashcard() {
    if (_currentIndex < widget.flashcardActivity.flashcards!.length - 1) {
      setState(() {
        _currentIndex++;
        _showDefinition = false; // Restablecer la vista de palabra
        _remainingTime = widget.flashcardActivity.timer; // Reiniciar el temporizador
      });
      _startTimer();
    }
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = widget.flashcardActivity.flashcards![_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Aprendizaje Flashcards"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "${_currentIndex + 1}/${widget.flashcardActivity.flashcards!.length}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              widget.flashcardActivity.name,
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _showDefinition
                      ? Text(
                    currentFlashcard.definition,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  )
                      : Text(
                    currentFlashcard.word,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Text(
              _remainingTime > 0 ? "00:${_remainingTime.toString().padLeft(2, '0')}" : "Tiempo agotado",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
            ),
            SizedBox(height: 16),
            _remainingTime > 0
                ? ElevatedButton(
              onPressed: () {
                setState(() {
                  _showDefinition = true;
                });
              },
              child: Text("Mostrar Definición"),
            )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _nextFlashcard,
              child: Text(_remainingTime > 0 ? "Saltar" : "Continuar"),
            ),
          ],
        ),
      ),
    );
  }
}
