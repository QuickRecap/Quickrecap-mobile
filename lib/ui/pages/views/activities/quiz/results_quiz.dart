import 'package:flutter/material.dart';
import '../widgets/info_container.dart';
import '../../../../../domain/entities/activity_review.dart';
import '../../../../../domain/entities/quiz_activity.dart';
import '../widgets/rating_dialog.dart'; // Importa el archivo
import 'play_quiz_activity.dart';
import 'review_answers_quiz.dart';
import '../../../../providers/add_user_points_provider.dart';
import 'package:provider/provider.dart';

class ResultsQuiz extends StatefulWidget {
  final ActivityReview activityReview;
  final QuizActivity quizActivity;

  ResultsQuiz({
    required this.quizActivity,
    required this.activityReview
  });

  @override
  State<ResultsQuiz> createState() => _ResultsQuizState();
}

class _ResultsQuizState extends State<ResultsQuiz> {

  @override
  void initState() {
    super.initState();
    // Llamamos a la función asíncrona dentro de Future para evitar el problema en initState
    Future.microtask(() => addUserPoints());
  }

// Función para agregar puntos al usuario
  Future<void> addUserPoints() async {
    final addUserPointsProvider = Provider.of<AddUserPointsProvider>(context, listen: false);
    try {
      bool success = await addUserPointsProvider.addUserPoints(widget.activityReview.score, widget.quizActivity.id, widget.activityReview.score ~/ 100, widget.quizActivity.quantity);
      if (success) {
        print("Puntos añadidos correctamente.");
      } else {
        print("Error al añadir puntos.");
      }
    } catch (e) {
      print("Excepción al añadir puntos: $e");
    } finally {
      // Aquí puedes hacer cualquier limpieza si es necesario
    }
  }

  // Función para convertir segundos a formato de minutos
  String formatTime(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString();
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo con imagen
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-authentication.png'), // Tu imagen de fondo
                fit: BoxFit.cover, // Ajuste de la imagen
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          '${widget.activityReview.activityType} \n completado',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 47,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(1),
                            width: 4, // Ajusta este valor según el grosor deseado
                          ),
                        ),
                        child: Text(
                          '+${widget.activityReview.score} puntos',  // Cambiado por el score
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 36,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      widget.quizActivity.isRated == false
                          ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xff7768fc), // Fondo del botón
                          foregroundColor: Colors.white, // Letra blanca
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white), // Borde blanco
                            borderRadius: BorderRadius.circular(17), // Bordes redondeados
                          ),
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (context) => RatingDialog(
                              activityId: widget.quizActivity.id,
                              activityType: 'Quiz',
                            ), // Usa el widget aquí
                          );
                        },
                        child: Text(
                          'Calificar juego',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Colors.white, // Asegurarse de que el texto sea blanco
                          ),
                        ),
                      )
                          : SizedBox.shrink(), // No muestra nada si está calificado
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InfoContainer(
                            title: 'Tiempo',
                            value: formatTime(widget.activityReview.totalSeconds),  // Formato del tiempo
                            icon: Icons.timer,
                          ),
                          InfoContainer(
                            title: 'Puntuacion',
                            value: '${widget.activityReview.correctAnswers}/${widget.activityReview.questions}',  // Cambiado por la puntuación
                            icon: Icons.adjust,
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Botón 'Continuar'
                      SizedBox(
                        width: 300, // Aquí puedes ajustar el ancho para todos los botones
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFFF6803), // Color #FF6803
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/entrypoint',
                              arguments: {
                                'initialIndex': 1    // Para asegurarte que la pestaña "Crear" esté seleccionada
                              },
                            );
                          },
                          child: Text(
                            'Finalizar',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Botón 'Ver respuestas' (Fondo transparente con borde blanco)
                      SizedBox(
                        width: 300,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white), // Borde blanco
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReviewAnswersQuiz(quizActivity: widget.quizActivity), // Usamos el operador ! para indicar que no es nulo
                              ),
                            );
                          },
                          child: Text(
                            'Ver respuestas',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Botón 'Volver a intentar' (Fondo transparente con borde blanco)
                      SizedBox(
                        width: 300,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white), // Borde blanco
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PlayQuizActivity(quizActivity: widget.quizActivity), // Usamos el operador ! para indicar que no es nulo
                              ),
                            );
                          },
                          child: Text(
                            'Volver a intentar',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Poppins',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 26),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
