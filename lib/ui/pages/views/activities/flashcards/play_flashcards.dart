import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async'; // Importamos Timer
import '../../../../../domain/entities/flashcard.dart';
import '../../../../../domain/entities/flashcard_activity.dart';

class PlayFlashcards extends StatefulWidget {
  final FlashcardActivity flashcardActivity;

  PlayFlashcards({required this.flashcardActivity});

  @override
  _PlayFlashcardsState createState() => _PlayFlashcardsState();
}

class _PlayFlashcardsState extends State<PlayFlashcards> with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  bool _showDefinition = false;
  late int _remainingTime;
  bool _timerStopped = false;
  bool _hasShownDefinition = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer; // Agregamos una variable para el Timer

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.flashcardActivity.timer;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelamos el timer al disponer el widget
    _controller.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel(); // Cancelamos cualquier timer existente
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0 && mounted && !_timerStopped) {
        setState(() {
          _remainingTime--;
        });
      } else if (_remainingTime == 0 && !_hasShownDefinition) {
        _flipCard();
        timer.cancel();
      } else {
        timer.cancel();
      }
    });
  }

  void _flipCard() {
    setState(() {
      if (_controller.status == AnimationStatus.completed) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _showDefinition = !_showDefinition;
      if (!_timerStopped) {
        _timerStopped = true;
        _hasShownDefinition = true;
      }
    });
  }

  void _nextFlashcard() {
    if (_currentIndex < widget.flashcardActivity.flashcards!.length - 1) {
      _timer?.cancel(); // Cancelamos el timer actual antes de iniciar uno nuevo
      setState(() {
        _currentIndex++;
        if (_showDefinition) {
          _controller.reverse();
          _showDefinition = false;
        }
        _timerStopped = false;
        _hasShownDefinition = false;
        _remainingTime = widget.flashcardActivity.timer;
      });
      _startTimer(); // Iniciamos un nuevo timer
    }
  }

  @override
  Widget build(BuildContext context) {
    Flashcard currentFlashcard = widget.flashcardActivity.flashcards![_currentIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Aprendizaje Flashcards",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(0x1A6D5BFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: (_currentIndex + 1) /
                          widget.flashcardActivity.flashcards!.length,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFF6D5BFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFF6D5BFF), // Color de fondo
                    borderRadius: BorderRadius.circular(10), // Bordes redondeados
                  ),
                  child: Text(
                    "${_currentIndex + 1}/${widget.flashcardActivity.flashcards!.length}",
                    style: TextStyle(
                      color: Colors.white, // Color del texto
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 16, // Ajusta el tamaño de la fuente según sea necesario
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Preparacion",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Center(
                child: GestureDetector(
                  onTap: _flipCard,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(math.pi * _animation.value),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(color: Color(0xFF6D5BFF), width: 2),
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: Transform(
                            alignment: Alignment.center,
                            transform: Matrix4.identity()
                              ..rotateY(_animation.value < 0.5 ? 0 : math.pi),
                            child: Text(
                              _animation.value < 0.5
                                  ? currentFlashcard.word
                                  : currentFlashcard.definition,
                              style: TextStyle(
                                color: Color(0xff212121),
                                fontSize: _animation.value < 0.5 ? 24 : 18,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 88,
              child: Center(
                child: !_timerStopped
                    ? Text(
                  "00:${_remainingTime.toString().padLeft(2, '0')}",
                  style: TextStyle(
                    color: Color(0xFF6D5BFF),
                    fontFamily: 'Poppins',
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                  ),
                )
                    : SizedBox(),
              ),
            ),
            !_hasShownDefinition
                ? ElevatedButton(
              onPressed: _nextFlashcard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              ),
              child: Text(
                "Saltar",
                style: TextStyle(
                  color: Color(0xFF474747),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 25,
                ),
              ),
            )
                : ElevatedButton(
              onPressed: _nextFlashcard,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF6D5BFF),
                minimumSize: Size(200, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 60),
              ),
              child: Text(
                "Continuar",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}