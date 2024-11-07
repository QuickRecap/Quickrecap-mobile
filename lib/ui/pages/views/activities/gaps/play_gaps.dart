import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/gaps.dart';
import '../../../../../domain/entities/gaps_activity.dart';
import '../../../../pages/views/activities/gaps/results_gaps.dart';
import '../../../../../domain/entities/activity_review.dart';
import '../widgets/timeout_dialog.dart';
import '../widgets/pause_dialog.dart';
import '../widgets/show_answer_dialog.dart';
import '../../../../../ui/providers/audio_provider.dart';
import 'package:provider/provider.dart';

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
  List<String> draggableWords = [];
  List<Answer?> answerSlots = [];
  List<String> correctAnswers = [];

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.gapsActivity.timer;
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
    Gaps currentGap = widget.gapsActivity.gaps![_currentIndex];
    List<String> textParts = currentGap.textWithGaps.split('&');

    // Obtén todas las opciones correctas
    List<String> allOptions = currentGap.answers.expand((answer) => answer.correctOptions).toList();

    // Añade las opciones incorrectas a la lista de opciones disponibles
    if (currentGap.incorrectAnswers != null && currentGap.incorrectAnswers!.isNotEmpty) {
      allOptions.addAll(currentGap.incorrectAnswers!);
    }

    // Calcula el espacio en blanco basado en la palabra más larga
    String blankSpace = calculateBlankSpace(allOptions);

    // Inicializa answerSlots con la posición correcta de cada hueco
    answerSlots = List.generate(
      textParts.length - 1,
          (index) => null,
    );

    draggableWords = allOptions;
    draggableWords.shuffle(); // Mezclar las palabras para que no estén en orden

    correctAnswers = List.generate(currentGap.answers.length, (index) =>
    currentGap.answers.firstWhere((answer) => answer.position == index).correctOptions[0]
    );
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
        final timeoutDialog = TimeoutDialog(onContinue: _nextGap);
        timeoutDialog.show(context);
      }
    });
  }

  void _nextGap() {
    _timer?.cancel();
    if (_currentIndex < widget.gapsActivity.gaps!.length - 1) {
      setState(() {
        _currentIndex++;
        _remainingTime = widget.gapsActivity.timer;
      });
      _initializeGapExercise();
      _startTimer();
    } else {
      // Finalizar la actividad
      ActivityReview activityReview = ActivityReview(
        activityId: widget.gapsActivity.id,
        activityType: "Gaps",
        totalSeconds: _elapsedTime,
        score: _score,
        questions: widget.gapsActivity.gaps!.length,
        correctAnswers: (_score / 100).toInt(),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ResultsGaps(
            activityReview: activityReview,
            gapsActivity: widget.gapsActivity,
          ),
        ),
            (Route<dynamic> route) => false, // Esto vacía la pila de navegación
      );
    }
  }

  Future<void> _checkAnswer() async {
    _timer?.cancel();
    bool allCorrect = true;
    List<Answer> selectedAnswers = [];

    for (int i = 0; i < answerSlots.length; i++) {
      if (answerSlots[i] != null) {
        selectedAnswers.add(answerSlots[i]!);

        // Comprobar si la respuesta es correcta
        if (answerSlots[i]!.correctOptions[0] != correctAnswers[i]) {
          allCorrect = false;
        }
      } else {
        // Si hay un hueco vacío, la respuesta no puede ser correcta
        allCorrect = false;
      }
    }

    widget.gapsActivity.gaps![_currentIndex].selectAnswers = selectedAnswers;

    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    await audioProvider.answerSound(allCorrect);

    if (allCorrect) {
      setState(() {
        _score += 100;
      });
      showAnswerDialog(
        context,
        correct: true,
        onContinue: _nextGap,
      );
    } else {
      showAnswerDialog(
        context,
        correct: false,
        onContinue: _nextGap,
      );
    }
  }

  void _resetGaps() {
    setState(() {
      _currentIndex = 0;
      _remainingTime = widget.gapsActivity.timer;
      _elapsedTime = 0; // Reinicia el tiempo transcurrido
      _score = 0;
      widget.gapsActivity.gaps![_currentIndex].selectAnswers=[];
    });
    _startTimer();
    _initializeGapExercise();
  }

  void _pauseQuiz() {
    _timer?.cancel();
    final pauseDialog = PauseDialog(
      onResume: _startTimer,
      onReset: _resetGaps,
    );
    pauseDialog.show(context);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Widget _buildDraggableWord(String word) {
    return Draggable<String>(
      data: word,
      child: Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Text(word, style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xff212121),
            fontSize: 18,
        )),
      ),
      feedback: Material(
        child: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(word, style: TextStyle(
              fontFamily: 'Poppins',
              color: Color(0xff212121),
          )),
        ),
      ),
      childWhenDragging: Container(),
    );
  }

  Widget _buildDragTarget(int index) {
    return DragTarget<String>(
      builder: (context, candidateData, rejectedData) {
        return GestureDetector(
          onTap: () {
            if (answerSlots[index] != null) {
              setState(() {
                draggableWords.add(answerSlots[index]!.correctOptions[0]);
                answerSlots[index] = null;
              });
            }
          },
          child: Container(
            constraints: BoxConstraints(minWidth: 120),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: answerSlots[index] != null ? Colors.white : Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
              border: answerSlots[index] != null ? Border.all(color: Color(0xFF6D5BFF)) : null,
            ),
            child: Text(
              answerSlots[index]?.correctOptions[0] ?? '',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xff212121), fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      onAccept: (word) {
        setState(() {
          answerSlots[index] = Answer(position: index, correctOptions: [word]);
          draggableWords.remove(word);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Gaps currentGap = widget.gapsActivity.gaps![_currentIndex];
    List<String> textParts = currentGap.textWithGaps.split('&');

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
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(30.0, 1.0, 30.0, 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Oracion ${_currentIndex + 1}",
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
                    SizedBox(height: 16),
                    // Contenedor con las palabras arrastrables
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      constraints: BoxConstraints(
                        minHeight: 70,
                      ),
                      child: SingleChildScrollView(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: draggableWords
                              .map((word) => _buildDraggableWord(word))
                              .toList(),
                        ),
                      ),
                    ),
                    Container(
                      height: 300, // Altura máxima fija
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: ScrollbarTheme(
                        data: ScrollbarThemeData(
                          thickness: MaterialStateProperty.all(6.0),
                          thumbColor: MaterialStateProperty.all(Color(
                              0xFF525252).withOpacity(0.6)),
                          radius: const Radius.circular(10),
                          minThumbLength: 80,
                        ),
                        child: Scrollbar(
                          thickness: 6,
                          thumbVisibility: true,
                          radius: Radius.circular(10),
                          child: SingleChildScrollView(
                            child: Container(
                              padding: EdgeInsets.all(20),
                              child: RichText(
                                textAlign: TextAlign.justify,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                    fontFamily: 'Poppins',
                                    height: 1.9,
                                  ),
                                  children: List.generate(textParts.length * 2 - 1, (index) {
                                    if (index.isEven) {
                                      return TextSpan(text: textParts[index ~/ 2]);
                                    } else {
                                      return WidgetSpan(
                                        child: IntrinsicWidth(
                                          child: _buildDragTarget(index ~/ 2),
                                        ),
                                      );
                                    }
                                  }),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 40.0, right: 40.0, bottom: 50.0, top: 50),
                      child: SizedBox(
                        width: 200.0, // Ancho deseado para el botón
                        child: ElevatedButton(
                          child: Text(
                            'Enviar',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 19,
                            ),
                          ),
                          // Validamos que todos los espacios estén llenos verificando que no haya nulls en answerSlots
                          onPressed: !answerSlots.contains(null) ? () => _checkAnswer() : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF6D5BFF),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              ),
            ),
          ),

        ],
      )

    );
  }


}