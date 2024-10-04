import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/quiz_activity.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/flashcard.dart';
import '../repositories/local_storage_service.dart';

class ActivityApi {
  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    // Obtener el userId desde el servicio de almacenamiento local
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/quickrecap/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Quiz",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: {
          'Content-Type': 'application/json',
        }
    );

    // Verificamos si el código de estado es 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      if (data['flashcards'] != null && data['quiz'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        List<Quiz> quizzes = (data['quiz'] as List)
            .map((quizJson) => Quiz.fromJson(quizJson))
            .toList();

        return QuizActivity(
          flashcards: flashcards,
          quizzes: quizzes,
        );
      } else {
        // Si los campos flashcards o quiz no están en la respuesta
        return null;
      }
    } else {
      // Si el código de estado no es 200 o 201
      print("Error en la petición. Código de estado: ${response.statusCode}");
      return null;
    }
  }

  Future<List<Flashcard>?> createFlashCard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    // Obtener el userId desde el servicio de almacenamiento local
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/activity/create'),
      body: jsonEncode({
        'tipo_actividad': "Flashcards",
        'tiempo_por_pregunta': activityTimer,
        'numero_preguntas': activityQuantity,
        'nombre': activityName,
        'pdf_url': pdfUrl,
        'usuario': userId,
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Verificamos si el código de estado es 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);

      if (data['flashcards'] != null && data['quiz'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        return flashcards;
      } else {
        // Si los campos flashcards o quiz no están en la respuesta
        return null;
      }
    } else {
      // Si el código de estado no es 200 o 201
      print("Error en la petición. Código de estado: ${response.statusCode}");
      return null;
    }
  }
}
