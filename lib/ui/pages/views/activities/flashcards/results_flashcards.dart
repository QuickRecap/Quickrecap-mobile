import 'package:flutter/material.dart';
import '../widgets/rating_dialog.dart';
import '../../../../../domain/entities/flashcard_activity.dart';
import '';

class ResultsFlashcards extends StatefulWidget {
  final FlashcardActivity flashcardActivity;

  ResultsFlashcards({
    required this.flashcardActivity,
  });

  @override
  State<ResultsFlashcards> createState() => _ResultsFlashcardsState();
}

class _ResultsFlashcardsState extends State<ResultsFlashcards> {

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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      'Flashcard \n completada',
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
                      '+100 puntos',  // Cambiado por el score
                      style: TextStyle(
                        fontSize: 36,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff7768fc), // Fondo transparente
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
                          activityId: widget.flashcardActivity.id,
                          activityType: 'Flashcards',
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
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
