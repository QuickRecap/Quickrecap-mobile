import 'package:flutter/material.dart';
import 'dart:async';
import '../../../../../domain/entities/gaps.dart';
import '../../../../../domain/entities/gaps_activity.dart';
import '../../../../pages/views/activities/gaps/results_gaps.dart';
import '../../../../../domain/entities/activity_review.dart';

class ReviewAnswersGaps extends StatefulWidget {
  final GapsActivity gapsActivity;

  ReviewAnswersGaps({required this.gapsActivity});

  @override
  _ReviewAnswersGapsState createState() => _ReviewAnswersGapsState();
}

class _ReviewAnswersGapsState extends State<ReviewAnswersGaps> {
  int _currentIndex = 0;
  List<String> draggableWords = [];
  List<String?> answerSlots = [];
  List<String> correctAnswers = [];

  @override
  void initState() {
    super.initState();
    _initializeGapExercise();
  }

  void _nextGap() {
    if (_currentIndex < widget.gapsActivity.gaps!.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousGap() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
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

    // Calcula el espacio en blanco basado en la palabra más larga
    String blankSpace = calculateBlankSpace(allOptions);

    answerSlots = List.generate(textParts.length - 1, (index) => null);

    draggableWords = allOptions;
    draggableWords.shuffle(); // Mezclar las palabras para que no estén en orden

    correctAnswers = List.generate(currentGap.answers.length, (index) =>
    currentGap.answers.firstWhere((answer) => answer.position == index).correctOptions[0]
    );
  }

  @override
  void dispose() {
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
                draggableWords.add(answerSlots[index]!);
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
              answerSlots[index] ?? '',
              style: TextStyle(fontFamily: 'Poppins', color: Color(0xff212121), fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      onAccept: (word) {
        setState(() {
          answerSlots[index] = word;
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
      body: SingleChildScrollView(
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
                ],
              ),
              SizedBox(height: 10),
              // Draggable words
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFFF1F1F1), // Color de fondo
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                constraints: BoxConstraints(
                  minHeight: 70, // Ajusta este valor al tamaño mínimo deseado
                ),
                child: SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: draggableWords.map((word) => _buildDraggableWord(word)).toList(),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Color de fondo
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Poppins',height: 1.9,),
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
              SizedBox(height: 30),

              SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _previousGap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7464FC),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // Ajusta el valor según tus necesidades
                      ),
                    ),
                    child: Text(
                      "Anterior",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: _nextGap,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7464FC),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // Ajusta el valor según tus necesidades
                      ),
                    ),
                    child: Text(
                      _currentIndex < widget.gapsActivity.gaps!.length - 1 ? "Siguiente" : "Salir",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}