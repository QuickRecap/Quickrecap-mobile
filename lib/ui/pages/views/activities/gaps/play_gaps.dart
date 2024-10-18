import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/gaps.dart';
import '../../../../../domain/entities/gaps_activity.dart';
import '../../../../pages/views/activities/quiz/results_quiz.dart';
import '../../../../../domain/entities/activity_review.dart';

class PlayGaps extends StatefulWidget {
  final GapsActivity gapsActivity;

  PlayGaps({required this.gapsActivity});

  @override
  _PlayGapsState createState() => _PlayGapsState();
}

class _PlayGapsState extends State<PlayGaps> {
  int _currentIndex = 0;
  int _score = 0;
  int _remainingTime = 0;
  int _elapsedTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.gapsActivity.timer;
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
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false, // No permite cerrar el modal tocando fuera
      enableDrag: false, // No permite arrastrar para cerrar
      backgroundColor: Colors.transparent, // Hace el fondo del modal transparente
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false, // Deshabilita el botón de atrás
          child: Container(
            width: MediaQuery.of(context).size.width, // Ocupa todo el ancho de la pantalla
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white, // Color de fondo blanco
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(15), // Bordes redondeados solo en la parte superior
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Ocupa el mínimo espacio necesario
              children: [
                Text(
                  "Tiempo Agotado",
                  style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212121), // Color del texto
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    _nextGap(); // Ejecuta la siguiente acción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6D5BFF), // Color del botón
                  ),
                  child: Text("Continuar", style: TextStyle(fontFamily: 'Poppins',fontWeight: FontWeight.w500, color: Colors.white),),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextGap() {
    if (_currentIndex < widget.gapsActivity.gaps!.length - 1) {
      setState(() {
        _currentIndex++;
        _remainingTime = widget.gapsActivity.timer;
      });
      _startTimer();
    }else{
      ActivityReview activityReview = ActivityReview(
        activityId: 10,
        activityType: "Gaps",
        totalSeconds: _elapsedTime, // Enviar el tiempo transcurrido
        score: _score,
        questions: widget.gapsActivity.gaps!.length,
        correctAnswers: (_score / 100).toInt(),
      );
      /*Navigator.push(
      );*/
    }
  }

  void _checkAnswer() {

  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _remainingTime = widget.gapsActivity.timer;
      _elapsedTime = 0; // Reinicia el tiempo transcurrido
      _score = 0;
    });
    _startTimer();
  }

  void _showAnswerDialog(BuildContext context, {required bool correct}) {
    _timer?.cancel();
    String message = correct ? "¡Buen Trabajo!" : "Oops, Tu respuesta no es correcta";
    String subMessage = "No te preocupes, sigue intentandolo";
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
                SizedBox(height: 10),
                Text(
                  message,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (correct) // Mostrar solo si la respuesta es correcta
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Padding dentro del container
                        decoration: BoxDecoration(
                          color: Colors.white, // Fondo blanco
                          borderRadius: BorderRadius.circular(20), // Bordes redondeados
                        ),
                        child: Text(
                          "+100 puntos",
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00C853), // Color del texto para la respuesta correcta
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    SizedBox(height: 10),
                    if (!correct) // Espacio entre los textos
                      Text(
                        subMessage,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                          color: textColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
                if (additionalMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      additionalMessage,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xff00C853),  // El texto de este mensaje es negro según el mockup
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _nextGap();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15), // Ajuste de tamaño del botón
                    textStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: buttonTextColor,
                    ),
                  ),
                  child: Text(
                    "Continuar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
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
      barrierDismissible: false, // El diálogo no se cierra al tocar fuera
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent, // Fondo transparente
          child: Container(
            padding: EdgeInsets.all(3), // Espacio para el borde
            decoration: BoxDecoration(
              color: Colors.white, // No se necesita color de fondo aquí
              borderRadius: BorderRadius.circular(20), // Borde redondeado externo
              border: Border.all(color: Color(0xFF6D5BFF), width: 3), // Borde de color
            ),
            child: Container(
              width: 200,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white, // Fondo blanco para el contenido del diálogo
                borderRadius: BorderRadius.circular(20), // Borde redondeado interno
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Pausa",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF212121),
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _startTimer();
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Color(0xFF6D5BFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.play_arrow,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                      SizedBox(width: 32),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          _resetQuiz();
                        },
                        child: Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: Color(0xFF6D5BFF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              ),
            ),
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
    Gaps currentGap = widget.gapsActivity.gaps![_currentIndex];

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
                  widthFactor: (_currentIndex + 1) /
                      widget.gapsActivity.gaps!.length,
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
              padding: const EdgeInsets.symmetric(
                  horizontal: 13.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Color(0xff6D5BFF),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Text(
                '${_currentIndex + 1}/${widget.gapsActivity.gaps!.length}',
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
                      color: Color(0xFF212121),
                    ),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.pause, color: Color(0xFF212121)),
                    onPressed: _pauseQuiz,
                  ),
                ],
              ),
              SizedBox(height: 16),
              Center(
              ),
              SizedBox(height: 20),
              Text(
                _remainingTime > 0 ? "00:${_remainingTime.toString().padLeft(
                    2, '0')}" : "00:00",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff6D5BFF),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              SizedBox(height: 30),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}