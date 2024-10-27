import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/quiz_activity.dart';
import '../../domain/entities/flashcard_activity.dart';
import '../../domain/entities/quiz.dart';
import '../../domain/entities/gaps.dart';
import '../../domain/entities/linkers.dart';
import '../../domain/entities/gaps_activity.dart';
import '../../domain/entities/linkers_activity.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/entities/activity.dart';
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
          'Content-Type': 'application/json; charset=UTF-8',  // Asegura UTF-8 en la cabecera
        }
    );

    // Verificamos si el código de estado es 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['flashcards'] != null && data['quiz'] != null && data['quiz'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        List<Quiz> quizzes = (data['quiz'] as List)
            .map((quizJson) => Quiz.fromJson(quizJson))
            .toList();

        return QuizActivity(
          flashcards: flashcards,
          quizzes: quizzes,
          id: data['activity']['id'],
          name: data['activity']['nombre'],
          quantity: data['activity']['numero_preguntas'],
          timer: data['activity']['tiempo_pregunta'],
          isRated: false,
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

  Future<GapsActivity?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    // Obtener el userId desde el servicio de almacenamiento local
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/quickrecap/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Gaps",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',  // Asegura UTF-8 en la cabecera
        }
    );

    // Verificamos si el código de estado es 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['flashcards'] != null && data['gaps'] != null && data['activity'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        List<Gaps> gaps = (data['gaps'] as List)
            .map((gapsJson) => Gaps.fromJson(gapsJson))
            .toList();

        return GapsActivity(
          flashcards: flashcards,
          gaps: gaps,
          id: data['activity']['id'],
          name: data['activity']['nombre'],
          quantity: data['activity']['numero_preguntas'],
          timer: data['activity']['tiempo_pregunta'],
          isRated: false,
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

  Future<LinkersActivity?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/quickrecap/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Linkers",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        }
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['flashcards'] != null && data['linkers'] != null && data['activity'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        List<Linkers> linkers = (data['linkers'] as List)
            .asMap()
            .map((index, linkersJson) => MapEntry(
          index,
          Linkers.fromJson(linkersJson, index),
        ))
            .values
            .toList();

        return LinkersActivity(
          flashcards: flashcards,
          linkers: linkers,
          id: data['activity']['id'],
          name: data['activity']['nombre'],
          quantity: data['activity']['numero_preguntas'],
          timer: data['activity']['tiempo_pregunta'],
          isRated: false,
        );
      } else {
        return null;
      }
    } else {
      print("Error en la petición. Código de estado: ${response.statusCode}");
      return null;
    }
  }

  Future<FlashcardActivity?> createFlashCard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
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
        'Content-Type': 'application/json; charset=UTF-8',  // Asegura UTF-8 en la cabecera
      },
    );

    // Verificamos si el código de estado es 200 o 201
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));

      if (data['flashcards'] != null) {
        List<Flashcard> flashcards = (data['flashcards'] as List)
            .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
            .toList();

        return FlashcardActivity(
            id: data['activity']['id'],
            flashcards: flashcards,
            name: data['activity']['nombre'],
            quantity: data['activity']['numero_preguntas'],
            timer: data['activity']['tiempo_pregunta'],
            isRated: false
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

  Future<bool> rateActivity(int activityId, int rating, String commentary) async{
    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/quickrecap/comments/create'),
      body: jsonEncode({
        "comentario": commentary,
        "calificacion": rating,
        "actividad_id": activityId,
        "usuario": userId
      }),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // Consider both 200 OK and 201 Created as successw
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Activity>> getActivityListByUserId(int tabIndex) async{

    LocalStorageService localStorageService = LocalStorageService();
    int userId = await localStorageService.getCurrentUserId();

    String baseUrl  = 'http://10.0.2.2:8000/quickrecap/activity/search/$userId';

    // Si el tabIndex es 1, agregamos el parámetro 'favorito'
    if (tabIndex == 1) {
      baseUrl = '?favorito=true';
    }

    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decodedData = json.decode(response.body);

        // Convertimos el JSON en una lista de actividades
        return decodedData.map((json) => Activity.fromJson(json)).toList();
      } else {
        throw Exception('Error al cargar las actividades');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }

  }
}
