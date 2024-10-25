import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/linkers.dart';
import '../../../../../domain/entities/linkers_activity.dart';
import '../../../../pages/views/activities/gaps/results_gaps.dart';
import '../../../../../domain/entities/activity_review.dart';

class PlayLinkers extends StatefulWidget {
  final LinkersActivity linkersActivity;

  PlayLinkers({required this.linkersActivity});

  @override
  _PlayLinkersState createState() => _PlayLinkersState();
}

class _PlayLinkersState extends State<PlayLinkers> {
  int _currentIndex = 0;
  int _score = 0;
  int _remainingTime = 0;
  int _elapsedTime = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.linkersActivity.timer;
    _startTimer();
    _initializeGapExercise();
  }

  String calculateBlankSpace(List<String> options) {
    // Encuentra la longitud de la palabra más larga
    int maxLength = options.fold(0, (max, word) => word.length > max ? word.length : max);

    // Agrega un poco de espacio extra para mejor presentación
    int totalSpace = maxLength + 10;

    // Crea una cadena de espacios invisibles
    return '‎ ' * totalSpace;
  }

  void _initializeGapExercise() {

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
                SizedBox(height: 13),
                Text(
                  "Tiempo Agotado",
                  style: TextStyle(
                    fontSize: 27,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: Color(0xff212121), // Color del texto
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  "¡Oops! Se acabó el tiempo...",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 21,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff727272),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Cierra el modal
                    _nextGap(); // Ejecuta la siguiente acción
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF6D5BFF), // Color del botón
                    padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0), // Padding del botón
                  ),
                  child: Text(
                    "Continuar",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  void _nextGap() {
    if (_currentIndex < widget.linkersActivity.linkers!.length - 1) {
      setState(() {
        _currentIndex++;
        _remainingTime = widget.linkersActivity.timer;
      });
      _initializeGapExercise();
      _startTimer();
    } else {
      // Finalizar la actividad
      ActivityReview activityReview = ActivityReview(
        activityId: widget.linkersActivity.id,
        activityType: "Linkers",
        totalSeconds: _elapsedTime,
        score: _score,
        questions: widget.linkersActivity.linkers!.length,
        correctAnswers: (_score / 100).toInt(),
      );
      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsGaps(
            activityReview: activityReview,
            gapsActivity: widget.linkersActivity,
          ), // Usamos el operador ! para indicar que no es nulo
        ),
      );*/
    }
  }

  void _checkAnswer() {
    bool allCorrect = true;

    if (allCorrect) {
      setState(() {
        _score += 100;
      });
      _showAnswerDialog(context, correct: true);
    } else {
      _showAnswerDialog(context, correct: false);
    }
  }

  void _resetLinkers() {
    setState(() {
      _currentIndex = 0;
      _remainingTime = widget.linkersActivity.timer;
      _elapsedTime = 0; // Reinicia el tiempo transcurrido
      _score = 0;
    });
    _startTimer();
    _initializeGapExercise();
  }

  void _showAnswerDialog(BuildContext context, {required bool correct}) {
    _timer?.cancel();
    String message = correct ? "¡Buen Trabajo!" : "Oops, Tu respuesta no es correcta";
    String subMessage = "No te preocupes, sigue intentandolo";
    String additionalMessage = correct ? "Excelente, continúa con la siguiente oracion" : "";
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
                          _resetLinkers();
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
    Linkers currentLinker = widget.linkersActivity.linkers![_currentIndex];
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
                        widget.linkersActivity.linkers!.length,
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
                  '${_currentIndex + 1}/${widget.linkersActivity.linkers!.length}',
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
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
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
                    ),
                    SizedBox(height: 10),
                    Text(
                      _remainingTime > 0
                          ? "00:${_remainingTime.toString().padLeft(2, '0')}"
                          : "00:00",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 40,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6D5BFF),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 30),
                    // Contenedor de las columnas sin padding horizontal
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Columna de palabras (izquierda)
                        Expanded(
                          child: Column(
                            children: currentLinker.linkerItems.map((item) {
                              return Container(
                                width: double.infinity,
                                margin: EdgeInsets.only(bottom: 15),
                                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Color(0xFF6D5BFF), width: 1),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Text(
                                  item.wordItem.content,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    color: Color(0xFF212121),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        // Columna de definiciones (derecha)
                        Expanded(
                          child: Column(
                            children: currentLinker.linkerItems.map((item) {
                              return GestureDetector(
                                onLongPress: () => _showDefinitionDialog(item.definitionItem.content),
                                child: Container(
                                  width: double.infinity,
                                  margin: EdgeInsets.only(bottom: 15),
                                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color(0xFF6D5BFF), width: 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Text(
                                    "...",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 16,
                                      color: Color(0xFF212121),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Pulsa los items para conectar",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          color: Color(0xFF727272),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(30.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          child: Text(
                            'Continuar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 23,
                            ),
                          ),
                          onPressed: _checkAnswer,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6D5BFF),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
    );
  }

// Método para mostrar el diálogo con la definición completa
  void _showDefinitionDialog(String definition) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Definición A',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 10),
              Text(
                definition,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF6D5BFF),
                  minimumSize: Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


}