import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/quiz.dart';
import '../../../../../domain/entities/quiz_activity.dart';

class PlayQuiz extends StatefulWidget {
  final QuizActivity quizActivity;

  PlayQuiz({required this.quizActivity});

  @override
  _PlayQuizState createState() => _PlayQuizState();
}

class _PlayQuizState extends State<PlayQuiz> {
  int _currentIndex = 0;
  bool _isAnswered = false;
  int _selectedAnswer = -1;
  int _score = 0;
  int _remainingTime = 0;
  Timer? _timer;

  final Color _primaryColor = Color(0xFF6D5BFF);
  final Color _successColor = Color(0xFF00B849);
  final Color _successLightColor = Color(0xFFBDFFC2);
  final Color _errorColor = Color(0xFFFF444E);
  final Color _errorLightColor = Color(0xFFFFCFD0);
  final Color _textColor = Color(0xFF212121);

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.quizActivity.timer;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: _errorLightColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Tiempo Agotado",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nextQuiz();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                  ),
                  child: Text("Continuar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextQuiz() {
    if (_currentIndex < widget.quizActivity.quizzes!.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswer = -1;
        _remainingTime = widget.quizActivity.timer;
      });
      _startTimer();
    }
  }

  void _checkAnswer() {
    Quiz currentQuiz = widget.quizActivity.quizzes![_currentIndex];
    if (_selectedAnswer == currentQuiz.answer) {
      _score += 100; // Sumar 100 puntos por respuesta correcta
      _showAnswerDialog(context, correct: true);
    } else {
      _showAnswerDialog(context, correct: false);
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _remainingTime = 10;
      _score = 0;
      _isAnswered = false;
    });
    _startTimer();
  }

  void _showAnswerDialog(BuildContext context, {required bool correct}) {
    _timer?.cancel();
    String message = correct ? "Buen Trabajo!" : "Oops, Tu respuesta no es correcta";
    String subMessage = correct ? "+100 puntos" : "";
    Color backgroundColor = correct ? _successLightColor : _errorLightColor;

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (subMessage.isNotEmpty)
                  Text(
                    subMessage,
                    style: TextStyle(
                      fontSize: 20,
                      color: _textColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nextQuiz();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                  ),
                  child: Text("Continuar"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _pauseQuiz() {
    _timer?.cancel();
    _showPauseDialog();
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Pausa",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _textColor,
            ),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _startTimer();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                ),
                child: Text("Reanudar"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _resetQuiz();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor,
                ),
                child: Text("Reiniciar"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Quiz currentQuiz = widget.quizActivity.quizzes![_currentIndex];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false, // Desactiva el botón de retroceso predeterminado
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: LinearProgressIndicator(
                    value: (_currentIndex + 1) / widget.quizActivity.quizzes!.length,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Color(0xff6D5BFF),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Text(
                  '${_currentIndex + 1}/${widget.quizActivity.quizzes!.length}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  "Pregunta ${_currentIndex + 1}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textColor,
                  ),
                ),
                Spacer(), // Este widget empuja los elementos a los extremos
                IconButton(
                  icon: Icon(Icons.pause, color: _textColor),
                  onPressed: _pauseQuiz,
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              currentQuiz.question,
              style: TextStyle(fontSize: 24, color: _textColor),
            ),
            SizedBox(height: 20),
            Text(
              _remainingTime > 0 ? "00:${_remainingTime.toString().padLeft(2, '0')}" : "00:00",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _textColor,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ...currentQuiz.alternatives.asMap().entries.map((entry) {
              int index = entry.key;
              String alternative = entry.value;
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: RadioListTile<int>(
                  title: Text(alternative, style: TextStyle(color: _textColor)),
                  value: index,
                  groupValue: _selectedAnswer,
                  activeColor: _primaryColor,
                  onChanged: (int? value) {
                    setState(() {
                      _selectedAnswer = value!;
                      _isAnswered = true;
                    });
                  },
                ),
              );
            }).toList(),
            Spacer(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isAnswered ? _checkAnswer : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text("Enviar", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
