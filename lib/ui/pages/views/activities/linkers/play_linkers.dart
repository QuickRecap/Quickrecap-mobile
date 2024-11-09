import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/linkers.dart';
import '../../../../../domain/entities/linkers_activity.dart';
import 'results_linkers.dart';
import '../../../../../domain/entities/activity_review.dart';
import '../widgets/timeout_dialog.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/show_answer_dialog.dart';
import '../../../../../ui/providers/audio_provider.dart';
import 'package:provider/provider.dart';

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

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.linkersActivity.timer;
    _startTimer();
    _initializeLinkerExercise();
    // Inicializar las conexiones vacías
    widget.linkersActivity.linkers!.forEach((linker) {
      if (linker.selectedLinkerItems == null) {
        linker.selectedLinkerItems = [];
      }
    });
  }

  // Método modificado para manejar la selección de words
  void _handleWordSelection(int index) {
    setState(() {
      var currentLinker = widget.linkersActivity.linkers![_currentIndex];
      // Verificar si el word está conectado
      final existingItemIndex = currentLinker.selectedLinkerItems?.indexWhere(
              (item) => item.wordItem.position == currentLinker.linkerItems[index].wordItem.position
      ) ?? -1;

      if (existingItemIndex != -1) {
        // Si está conectado, eliminar la conexión
        currentLinker.selectedLinkerItems?.removeAt(existingItemIndex);
        selectedWordIndex = null;
        selectedDefinitionIndex = null;
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

  // Método modificado para manejar la selección de definitions
  void _handleDefinitionSelection(int index) {
    setState(() {
      var currentLinker = widget.linkersActivity.linkers![_currentIndex];
      // Verificar si la definition está conectada
      final existingItemIndex = currentLinker.selectedLinkerItems?.indexWhere(
              (item) => item.definitionItem.position == currentLinker.linkerItems[index].definitionItem.position
      ) ?? -1;

      if (existingItemIndex != -1) {
        // Si está conectada, eliminar la conexión
        currentLinker.selectedLinkerItems?.removeAt(existingItemIndex);
        selectedWordIndex = null;
        selectedDefinitionIndex = null;
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
    var currentLinker = widget.linkersActivity.linkers![_currentIndex];

    // Crear un nuevo LinkerItem que conecte los elementos seleccionados por el usuario
    var selectedWord = currentLinker.linkerItems[wordIndex].wordItem;
    var selectedDefinition = currentLinker.linkerItems[definitionIndex].definitionItem;

    // Eliminar conexiones previas que involucren cualquiera de los elementos
    currentLinker.selectedLinkerItems?.removeWhere((item) =>
    item.wordItem.position == selectedWord.position ||
        item.definitionItem.position == selectedDefinition.position
    );

    // Crear un nuevo LinkerItem con la conexión seleccionada por el usuario
    var newConnection = LinkerItem(
        wordItem: selectedWord,
        definitionItem: selectedDefinition
    );

    // Agregar la nueva conexión
    currentLinker.selectedLinkerItems?.add(newConnection);
  }

  void _initializeLinkerExercise() {
    // Limpiar las conexiones al inicializar
    setState(() {
      // Limpiar las conexiones al inicializar
      widget.linkersActivity.linkers![_currentIndex].selectedLinkerItems=[];
      selectedWordIndex = null;
      selectedDefinitionIndex = null;
    });
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
        // Asegurarnos de que selectedLinkerItems esté inicializado para el siguiente ejercicio
        if (widget.linkersActivity.linkers![_currentIndex].selectedLinkerItems == null) {
          widget.linkersActivity.linkers![_currentIndex].selectedLinkerItems = [];
        }
        selectedWordIndex = null;
        selectedDefinitionIndex = null;
      });
      _initializeLinkerExercise();
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
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsLinkers(
            activityReview: activityReview,
            linkersActivity: widget.linkersActivity,
          ),
        ),
            (Route<dynamic> route) => false, // Esto vacía la pila de navegación
      );

    }
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

  Future<void> _checkAnswer() async {
    _timer?.cancel();
    var currentLinker = widget.linkersActivity.linkers![_currentIndex];
    bool allCorrect = true;

    if (currentLinker.selectedLinkerItems?.length != currentLinker.linkerItems.length) {
      allCorrect = false;
    } else {
      for (var selectedItem in currentLinker.selectedLinkerItems!) {
        // Buscamos la definición original que corresponde a la palabra seleccionada
        var originalDefinitionPosition = selectedItem.wordItem.position;

        // La respuesta es correcta si la definición seleccionada tiene la misma posición
        // que la posición original de la palabra
        bool isCorrect = selectedItem.definitionItem.position == originalDefinitionPosition;

        if (!isCorrect) {
          allCorrect = false;
        }
      }
    }

    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    await audioProvider.answerSound(allCorrect);

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
    _initializeLinkerExercise();
  }

  void _pauseQuiz() {
    _timer?.cancel();
    final pauseDialog = PauseDialog(
      onResume: _startTimer,
      onReset: _resetLinkers,
    );
    pauseDialog.show(context);
  }

  bool _areAllItemsConnected() {
    var currentLinker = widget.linkersActivity.linkers![_currentIndex];
    // Verifica si el número de conexiones es igual al número de items
    return currentLinker.selectedLinkerItems?.length == currentLinker.linkerItems.length;
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
                    color: Colors.white,
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
                          _formatTime(_remainingTime),
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff6D5BFF),
                          ),
                          textAlign: TextAlign.center,
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
                        SizedBox(height: 30),

                        // Contenedor de las columnas con Stack para las líneas
                        Stack(
                          children: [
                            // Primero dibujamos las líneas de conexión
                            ...currentLinker.selectedLinkerItems!.map((linkerItem) {
                              // Encontrar los índices correspondientes en el array de linkerItems
                              int wordIndex = currentLinker.linkerItems.indexWhere(
                                    (item) => item.wordItem.position == linkerItem.wordItem.position,
                              );
                              int definitionIndex = currentLinker.linkerItems.indexWhere(
                                    (item) => item.definitionItem.position == linkerItem.definitionItem.position,
                              );

                              return CustomPaint(
                                painter: LinePainter(
                                  startIndex: wordIndex,
                                  endIndex: definitionIndex,
                                  color: Color(0xFF6D5BFF),
                                ),
                                size: Size(
                                  MediaQuery.of(context).size.width,
                                  containerHeight * currentLinker.linkerItems.length,
                                ),
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
                                      children: currentLinker.linkerItems.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedWordIndex == index;
                                        bool isConnected = currentLinker.selectedLinkerItems!.any(
                                                (selectedItem) => selectedItem.wordItem.position == item.wordItem.position
                                        );

                                        return GestureDetector(
                                          onTap: () => _handleWordSelection(index),
                                          onLongPress: () => _showContentDialog(item.wordItem.content, 'Palabra'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            height: containerHeight,
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF6D5BFF), width: 1),
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
                                      children: currentLinker.linkerItems.asMap().entries.map((entry) {
                                        int index = entry.key;
                                        var item = entry.value;
                                        bool isSelected = selectedDefinitionIndex == index;
                                        bool isConnected = currentLinker.selectedLinkerItems!.any(
                                                (selectedItem) => selectedItem.definitionItem.position == item.definitionItem.position
                                        );

                                        return GestureDetector(
                                          onTap: () => _handleDefinitionSelection(index),
                                          onLongPress: () => _showContentDialog(item.definitionItem.content, 'Definición'),
                                          child: Container(
                                            width: MediaQuery.of(context).size.width * 0.35,
                                            height: containerHeight,
                                            margin: EdgeInsets.only(bottom: 35),
                                            padding: EdgeInsets.symmetric(horizontal: 12),
                                            decoration: BoxDecoration(
                                              border: Border.all(color: Color(0xFF6D5BFF), width: 1),
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
                            "Manten presionado para ver el texto completo",
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
                                  fontSize: 18,
                                ),
                              ),
                              onPressed: _areAllItemsConnected() ? _checkAnswer : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _areAllItemsConnected()
                                    ? Color(0xFF6D5BFF)
                                    : Color(0xFF6D5BFF).withOpacity(0.5),
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
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;

    // Ajustamos las medidas para coincidir con el layout
    final containerHeight = 100.0; // Altura total incluyendo el margen
    final containerActualHeight = 70.0; // Altura real del contenedor
    final containerWidth = size.width * 0.35;
    final gap = size.width * 0.3;

    // Calculamos la posición Y considerando el margen superior inicial y la altura del contenedor
    final startY = (startIndex * containerHeight) + (containerActualHeight / 2);
    final endY = (endIndex * containerHeight) + (containerActualHeight / 2);

    // Definimos los puntos de inicio y fin
    final startPoint = Offset(containerWidth, startY);
    final endPoint = Offset(size.width - containerWidth, endY);

    // Dibujamos la línea
    final path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);

    // Puntos de control para la curva
    final controlPoint1 = Offset(
        startPoint.dx + gap * 0.5,
        startY
    );
    final controlPoint2 = Offset(
        endPoint.dx - gap * 0.5,
        endY
    );

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