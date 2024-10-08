import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/quiz.dart';
import '../../../../../domain/entities/quiz_activity.dart';
import 'package:dotted_border/dotted_border.dart';

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
    String message = correct ? "¡Buen Trabajo!" : "Oops, Tu respuesta no es correcta";
    String subMessage = correct ? "+100 puntos" : "Casi adivinas la respuesta correcta, inténtalo de nuevo";
    String additionalMessage = correct ? "Excelente, continúa con la siguiente pregunta" : "";
    Color backgroundColor = correct ? Color(0xFFBDFFC2) : Color(0xFFFFCFD0);
    Color textColor = correct ? Color(0xFF00C853) : Color(0xFFF44337);
    Color buttonTextColor = correct ? Color(0xFF00C853) : Color(0xFFF44337);

    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            width: MediaQuery.of(context).size.width,  // Siempre ocupará todo el ancho
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
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  subMessage,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (additionalMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      additionalMessage,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,  // El texto de este mensaje es negro según el mockup
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nextQuiz();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Ajuste de tamaño del botón
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: buttonTextColor,
                    ),
                  ),
                  child: Text(
                    "Continuar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: buttonTextColor,
                    ),
                  ),
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
        backgroundColor: Color(0xFFF6F8FC),
        appBar: AppBar(
          backgroundColor: Color(0xFFF6F8FC),
          elevation: 0,
          automaticallyImplyLeading: false, // Desactiva el botón de retroceso predeterminado
          title: Row(
            children: [
              IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.0), // Margen horizontal
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
        body: Padding(
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
                Spacer(), // Este widget empuja los elementos a los extremos
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
                radius: Radius.circular(20), // Borde redondeado
                dashPattern: [5, 5], // Patrón de puntos y espacios
                color: Color(0xff6D5BFF), // Color del borde
                strokeWidth: 3, // Ancho del borde
                padding: EdgeInsets.all(0), // Padding interno del borde punteado
                child: Card(
                  color: Colors.white, // Fondo blanco
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20), // Misma curva que el borde punteado
                  ),
                  elevation: 0, // Eliminar la sombra
                  margin: EdgeInsets.all(0), // Reducir cualquier margen extra
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                    child: Center(
                      child: Text(
                        currentQuiz.question,
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(0xff212121),
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500, // Fuente personalizada si es necesario
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
              _remainingTime > 0 ? "00:${_remainingTime.toString().padLeft(2, '0')}" : "00:00",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Color(0xff6D5BFF),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ...currentQuiz.alternatives.asMap().entries.map((entry) {
              int index = entry.key;
              String alternative = entry.value;

              // Determinar el color de fondo y texto según el estado
              Color backgroundColor;
              Color textColor = Color(0xff212121);  // Color por defecto para el texto

              // Si ya se ha enviado la respuesta, mostrar colores de correcto o incorrecto
              if (!_isAnswered) {
                // Si no se ha enviado aún, cambiar a morado solo la opción seleccionada
                backgroundColor = (index == _selectedAnswer)
                    ? Color(0xFF6D5BFF)  // Morado si está seleccionada pero aún no enviada
                    : Colors.white;  // Fondo blanco para alternativas no seleccionadas
              } else {
                // Si no se ha enviado aún, cambiar a morado solo la opción seleccionada
                backgroundColor = (index == _selectedAnswer)
                    ? Color(0xFF6D5BFF)  // Morado si está seleccionada pero aún no enviada
                    : Colors.white;  // Fondo blanco para alternativas no seleccionadas
              }
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: GestureDetector(
                  onTap: !_isAnswered ? () {
                    setState(() {
                      _selectedAnswer = index;  // Actualizar la respuesta seleccionada
                    });
                  } : null,  // Solo permitir selección si no se ha respondido
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: (index == _selectedAnswer && !_isAnswered)
                            ? Color(0xFF6D5BFF)  // Borde morado para la selección antes de enviar
                            : Color(0xffE1E1E1),  // Borde gris para no seleccionadas o ya enviadas
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
            Spacer(),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _selectedAnswer != null ? _checkAnswer : null,  // Habilitar solo si hay una selección
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
