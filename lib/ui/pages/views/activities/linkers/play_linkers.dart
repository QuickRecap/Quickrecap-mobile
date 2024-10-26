import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/linkers.dart';
import '../../../../../domain/entities/linkers_activity.dart';
import '../../../../pages/views/activities/gaps/results_gaps.dart';
import '../../../../../domain/entities/activity_review.dart';
import '../widgets/timeout_dialog.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/show_answer_dialog.dart';

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
  int? selectedWordIndex;
  int? selectedDefinitionIndex;
  List<Map<String, int>> connections = []; // Guarda las conexiones actuales

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.linkersActivity.timer;
    _startTimer();
    _initializeGapExercise();
    // Inicializar las conexiones vacías
    connections = [];
  }

  // Método para manejar la selección de words
  void _handleWordSelection(int index) {
    setState(() {
      if (selectedWordIndex == index) {
        // Si se selecciona la misma word, deseleccionar
        selectedWordIndex = null;
        // Si tiene una conexión, eliminarla
        connections.removeWhere((connection) => connection['wordIndex'] == index);
      } else {
        if (selectedDefinitionIndex != null) {
          // Si hay una definición seleccionada, crear conexión
          _createConnection(index, selectedDefinitionIndex!);
          selectedWordIndex = null;
          selectedDefinitionIndex = null;
        } else {
          // Seleccionar word
          selectedWordIndex = index;
          selectedDefinitionIndex = null;
        }
      }
    });
  }

  // Método para manejar la selección de definitions
  void _handleDefinitionSelection(int index) {
    setState(() {
      if (selectedDefinitionIndex == index) {
        // Si se selecciona la misma definition, deseleccionar
        selectedDefinitionIndex = null;
        // Si tiene una conexión, eliminarla
        connections.removeWhere((connection) => connection['definitionIndex'] == index);
      } else {
        if (selectedWordIndex != null) {
          // Si hay una word seleccionada, crear conexión
          _createConnection(selectedWordIndex!, index);
          selectedWordIndex = null;
          selectedDefinitionIndex = null;
        } else {
          // Seleccionar definition
          selectedDefinitionIndex = index;
          selectedWordIndex = null;
        }
      }
    });
  }

  // Método para crear conexiones
  void _createConnection(int wordIndex, int definitionIndex) {
    // Eliminar conexiones previas de cualquiera de los elementos
    connections.removeWhere((connection) =>
    connection['wordIndex'] == wordIndex ||
        connection['definitionIndex'] == definitionIndex
    );

    // Agregar nueva conexión
    connections.add({
      'wordIndex': wordIndex,
      'definitionIndex': definitionIndex,
    });
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
        // Reemplazar _showTimeUpDialog() con:
        final timeoutDialog = TimeoutDialog(onContinue: _nextLinker);
        timeoutDialog.show(context);
      }
    });
  }

  void _nextLinker() {
    _timer?.cancel();
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
    _timer?.cancel();
    bool allCorrect = true;

    if (allCorrect) {
      setState(() {
        _score += 100;
      });
      showAnswerDialog(
        context,
        correct: true,
        onContinue: _nextLinker,
      );
    } else {
      showAnswerDialog(
        context,
        correct: false,
        onContinue: _nextLinker,
      );
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

  void _pauseQuiz() {
    _timer?.cancel();
    final pauseDialog = PauseDialog(
      onResume: _startTimer,
      onReset: _resetLinkers,
    );
    pauseDialog.show(context);
  }

  void _showContentDialog(String content, String type) {
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
                type,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF212121),
                ),
              ),
              SizedBox(height: 10),
              Text(
                content,
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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Linkers currentLinker = widget.linkersActivity.linkers![_currentIndex];

    // Calculamos la altura para dos líneas de texto
    final double containerHeight = (TextStyle(
      fontFamily: 'Poppins',
      fontSize: 20,
    ).fontSize! * 1.2 * 2) + 16; // 2 líneas * altura de línea + padding vertical

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
        body: Stack(
          children: [
            Column(
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
                        SizedBox(height: 30),
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

                        // Contenedor de las columnas con Stack para las líneas
                        Stack(
                          children: [
                            // Primero dibujamos las líneas de conexión
                            ...connections.map((connection) {
                              return CustomPaint(
                                painter: LinePainter(
                                  startIndex: connection['wordIndex']!,
                                  endIndex: connection['definitionIndex']!,
                                  color: Color(0xFF6D5BFF),
                                ),
                                size: Size(MediaQuery.of(context).size.width,
                                    containerHeight * currentLinker.linkerItems.length),
                              );
                            }).toList(),

                            // Luego las columnas de words y definitions
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Columna de palabras (izquierda)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20),
                                    child: Column(
                                      children: currentLinker.linkerItems.asMap().entries
                                          .map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedWordIndex == index;
                                        bool isConnected = connections.any(
                                                (c) => c['wordIndex'] == index);

                                        return GestureDetector(
                                          onTap: () => _handleWordSelection(index),
                                          onLongPress: () => _showContentDialog(
                                              item.wordItem.content, 'Palabra'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.35,
                                            height: containerHeight, // Altura fija para dos líneas
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF6D5BFF), width: 1),
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(15),
                                                bottomRight: Radius.circular(15),
                                              ),
                                              color: isSelected || isConnected
                                                  ? Color(0xFF6D5BFF)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.wordItem.content,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 17,
                                                  color: isSelected || isConnected
                                                      ? Colors.white
                                                      : Color(0xFF212121),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 70),
                                // Columna de definiciones (derecha)
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Column(
                                      children: currentLinker.linkerItems.asMap().entries
                                          .map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedDefinitionIndex == index;
                                        bool isConnected = connections.any(
                                                (c) => c['definitionIndex'] == index);

                                        return GestureDetector(
                                          onTap: () => _handleDefinitionSelection(index),
                                          onLongPress: () => _showContentDialog(
                                              item.definitionItem.content, 'Definición'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width *
                                                0.35,
                                            height: containerHeight, // Altura fija para dos líneas
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Color(0xFF6D5BFF), width: 1),
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(15),
                                                bottomLeft: Radius.circular(15),
                                              ),
                                              color: isSelected || isConnected
                                                  ? Color(0xFF6D5BFF)
                                                  : Colors.white,
                                            ),
                                            child: Center(
                                              child: Text(
                                                item.definitionItem.content,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 17,
                                                  color: isSelected || isConnected
                                                      ? Colors.white
                                                      : Color(0xFF212121),
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
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
            ),
          ],
        )
    );
  }

}

class LinePainter extends CustomPainter {
  final int startIndex;
  final int endIndex;
  final Color color;

  LinePainter({
    required this.startIndex,
    required this.endIndex,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Calculamos el espacio total disponible y la altura de cada contenedor
    final containerHeight = 70.0; // Altura del contenedor + margen inferior (35)
    final containerWidth = size.width * 0.35; // 35% del ancho total
    final gap = size.width * 0.3; // 30% del ancho para el espacio entre contenedores

    // Calculamos los puntos de inicio y fin
    final startY = (containerHeight * startIndex) + (containerHeight / 2) + 20; // Añadimos offset vertical
    final endY = (containerHeight * endIndex) + (containerHeight / 2) + 20; // Añadimos offset vertical

    // Punto de inicio (desde el borde derecho del contenedor izquierdo)
    final startPoint = Offset(containerWidth, startY);
    
    // Punto final (desde el borde izquierdo del contenedor derecho)
    final endPoint = Offset(size.width - containerWidth, endY);

    // Dibujamos la línea
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    
    // Creamos una curva suave entre los puntos
    final controlPoint1 = Offset(startPoint.dx + gap / 3, startPoint.dy);
    final controlPoint2 = Offset(endPoint.dx - gap / 3, endY);
    
    path.cubicTo(
      controlPoint1.dx, controlPoint1.dy,
      controlPoint2.dx, controlPoint2.dy,
      endPoint.dx, endPoint.dy
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}