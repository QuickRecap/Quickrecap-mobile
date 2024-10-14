import 'package:flutter/material.dart';
import '../../../../../domain/entities/quiz_activity.dart';
import '../../../../../domain/entities/quiz.dart';
import 'package:dotted_border/dotted_border.dart';

class ReviewAnswersQuiz extends StatefulWidget {
  final QuizActivity quizActivity;

  ReviewAnswersQuiz({required this.quizActivity});

  @override
  State<ReviewAnswersQuiz> createState() => _ReviewAnswersQuizState();
}

class _ReviewAnswersQuizState extends State<ReviewAnswersQuiz> {
  int _currentIndex = 0;

  void _nextQuestion() {
    if (_currentIndex < widget.quizActivity.quizzes!.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousQuestion() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Quiz currentQuiz = widget.quizActivity.quizzes![_currentIndex];

    // Verificar si la respuesta seleccionada es correcta
    bool isCorrect = currentQuiz.answer == currentQuiz.selectedAnswer;

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
              Text(
                "Pregunta ${_currentIndex + 1}",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Color(0xff212121),
                ),
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
              SizedBox(height: 16),
              ...currentQuiz.alternatives.asMap().entries.map((entry) {
                int index = entry.key;
                String alternative = entry.value;
                bool isSelected = index == currentQuiz.selectedAnswer;
                bool isCorrectAnswer = index == currentQuiz.answer;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Stack(
                    clipBehavior: Clip.none, // Permite que los íconos sobresalgan del contenedor
                    children: [
                      Container(
                        width: double.infinity, // Asegura que el ancho del contenedor sea completo
                        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected ? Color(0xFF6D5BFF) : Color(0xffE1E1E1),
                            width: 2,
                          ),
                        ),
                        child: Text(
                          alternative,
                          style: TextStyle(
                            color: Color(0xff212121),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      if (isCorrectAnswer)
                        Positioned(
                          right: -8, // Se sobresale un poco fuera del contenedor
                          top: -8,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.green,
                                size: 30,
                              ),
                            ],
                          ),
                        ),
                      if (isSelected && !isCorrectAnswer)
                        Positioned(
                          top: -10,
                          right: -10,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Color(0xFFFF444E),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: 30),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _previousQuestion,
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
                    onPressed: _nextQuestion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7464FC),
                      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                      disabledBackgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(17), // Ajusta el valor según tus necesidades
                      ),
                    ),
                    child: Text(
                      _currentIndex < widget.quizActivity.quizzes!.length - 1 ? "Siguiente" : "Salir",
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
