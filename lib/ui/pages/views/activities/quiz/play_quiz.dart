import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/quiz.dart';
import '../../../../../domain/entities/quiz_activity.dart';
import '../../../../pages/views/activities/quiz/results_quiz.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../../../../domain/entities/activity_review.dart';
import '../widgets/timeout_dialog.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/show_answer_dialog.dart';
import '../../../../../ui/providers/audio_provider.dart';
import 'package:provider/provider.dart';


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
  int _elapsedTime = 0;
  Timer? _timer;

  final Color _primaryColor = Color(0xFF6D5BFF);
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
          _elapsedTime++; // Incrementa el tiempo transcurrido solo si el temporizador está en marcha
        });
      } else {
        _timer?.cancel();
        // Reemplazar _showTimeUpDialog() con:
        final timeoutDialog = TimeoutDialog(onContinue: _nextQuiz);
        timeoutDialog.show(context);
      }
    });
  }

  String _formatTime(int totalSeconds) {
    if (totalSeconds <= 0) return "00:00";

    int minutes = totalSeconds ~/ 60;  // Integer division to get minutes
    int seconds = totalSeconds % 60;   // Remainder to get seconds

    // Pad with zeros if needed
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  void _nextQuiz() {
    _timer?.cancel();
    if (_currentIndex < widget.quizActivity.quizzes!.length - 1) {
      setState(() {
        _currentIndex++;
        _isAnswered = false;
        _selectedAnswer = -1;
        _remainingTime = widget.quizActivity.timer;
      });
      _startTimer();
    }else{
      ActivityReview activityReview = ActivityReview(
          activityId: 10,
          activityType: "Quiz",
          totalSeconds: _elapsedTime, // Enviar el tiempo transcurrido
          score: _score,
          questions: widget.quizActivity.quizzes!.length,
          correctAnswers: (_score / 100).toInt(),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsQuiz(
            activityReview: activityReview,
            quizActivity: widget.quizActivity,
          ),
        ),
            (Route<dynamic> route) => false, // Esto vacía la pila de navegación
      );
    }
  }

  Future<void> _checkAnswer() async {
    _timer?.cancel();

    // Asigna la respuesta seleccionada al quiz actual antes de hacer la validación
    widget.quizActivity.quizzes![_currentIndex].selectedAnswer = _selectedAnswer;

    Quiz currentQuiz = widget.quizActivity.quizzes![_currentIndex];

    final audioProvider = Provider.of<AudioProvider>(context, listen: false);

    bool isCorrect = _selectedAnswer == currentQuiz.answer;
    await audioProvider.answerSound(isCorrect);

    if (isCorrect) {
      _score += 100; // Sumar 100 puntos por respuesta correcta
      showAnswerDialog(
        context,
        correct: true,
        onContinue: _nextQuiz,
      );
    } else {
      showAnswerDialog(
        context,
        correct: false,
        onContinue: _nextQuiz,
      );
    }
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _remainingTime = widget.quizActivity.timer;
      _elapsedTime = 0; // Reinicia el tiempo transcurrido
      _score = 0;
      _isAnswered = false;
      _selectedAnswer = -1;
    });
    _startTimer();
  }

  void _pauseQuiz() {
    _timer?.cancel();
    final pauseDialog = PauseDialog(
      onResume: _startTimer,
      onReset: _resetQuiz,
    );
    pauseDialog.show(context);
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
      backgroundColor: Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: Color(0xFFF6F8FC),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.close, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                height: 13,
                decoration: BoxDecoration(
                  color: Color(0x1A6D5BFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (_currentIndex + 1) / widget.quizActivity.quizzes!.length,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF6D5BFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Color(0xff6D5BFF),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.quizActivity.quizzes!.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.0, 1.0, 30.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Text(
                    "Pregunta ${_currentIndex + 1}",
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: _textColor,
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.pause, color: _textColor),
                    onPressed: _pauseQuiz,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  radius: Radius.circular(20),
                  dashPattern: [5, 5],
                  color: Color(0xff6D5BFF),
                  strokeWidth: 3,
                  padding: EdgeInsets.all(0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                    margin: EdgeInsets.all(0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                      child: Center(
                        child: Text(
                          currentQuiz.question,
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xff212121),
                            fontFamily: 'poppins',
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                _formatTime(_remainingTime),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff6D5BFF),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ...currentQuiz.alternatives.asMap().entries.map((entry) {
                int index = entry.key;
                String alternative = entry.value;

                Color backgroundColor;
                Color textColor = Color(0xff212121);

                if (!_isAnswered) {
                  backgroundColor = (index == _selectedAnswer)
                      ? Color(0xFF6D5BFF)
                      : Colors.white;
                  textColor = (index == _selectedAnswer)
                      ? Colors.white
                      : Color(0xff212121);
                } else {
                  backgroundColor = (index == _selectedAnswer)
                      ? Color(0xFF6D5BFF)
                      : Colors.white;
                }
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: GestureDetector(
                    onTap: !_isAnswered ? () {
                      setState(() {
                        _selectedAnswer = index;
                      });
                    } : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        color: backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: (index == _selectedAnswer && !_isAnswered)
                              ? Color(0xFF6D5BFF)
                              : Color(0xffE1E1E1),
                          width: 2,
                        ),
                      ),
                      child: Text(
                        alternative,
                        style: TextStyle(
                          color: textColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _selectedAnswer != -1 ? () => _checkAnswer() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _primaryColor, // Color del fondo cuando está habilitado
                  padding: EdgeInsets.symmetric(vertical: 16),
                  disabledBackgroundColor: Colors.grey[300], // Color de fondo cuando está deshabilitado
                ),
                child: Text(
                  "Enviar",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: _selectedAnswer != -1 ? Colors.white : Color(0xFF7A7C7F), // Color del texto
                  ),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
