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
import '../../domain/entities/results.dart';
import '../repositories/local_storage_service.dart';

class ActivityApi {
  final String baseUrl = 'https://quickrecap.rj.r.appspot.com/quickrecap';
  final Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final LocalStorageService localStorageService = LocalStorageService();

  Future<Result<QuizActivity>> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Quiz",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['flashcards'] != null && data['quiz'] != null && data['activity'] != null) {
          List<Flashcard> flashcards = (data['flashcards'] as List)
              .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
              .toList();

          List<Quiz> quizzes = (data['quiz'] as List)
              .map((quizJson) => Quiz.fromJson(quizJson))
              .toList();

          final activity = QuizActivity(
            flashcards: flashcards,
            quizzes: quizzes,
            id: data['activity']['id'],
            name: data['activity']['nombre'],
            quantity: data['activity']['numero_preguntas'],
            timer: data['activity']['tiempo_pregunta'],
            isRated: false,
          );

          return Result(data: activity);
        }
      }

      if (response.statusCode == 400) {
        return Result(
          error: 'Error 400: Este nombre ya está asignado a otra actividad',
          statusCode: response.statusCode,
        );
      }

      return Result(
        error: 'Error al crear Quiz: ${response.statusCode}',
        statusCode: response.statusCode,
      );

    } catch (e) {
      print('Error en createQuiz: $e');
      return Result(error: e.toString());
    }
  }

  Future<Result<GapsActivity>> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Gaps",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['flashcards'] != null && data['gaps'] != null && data['activity'] != null) {
          List<Flashcard> flashcards = (data['flashcards'] as List)
              .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
              .toList();

          List<Gaps> gaps = (data['gaps'] as List)
              .map((gapsJson) => Gaps.fromJson(gapsJson))
              .toList();

          final activity = GapsActivity(
            flashcards: flashcards,
            gaps: gaps,
            id: data['activity']['id'],
            name: data['activity']['nombre'],
            quantity: data['activity']['numero_preguntas'],
            timer: data['activity']['tiempo_pregunta'],
            isRated: false,
          );

          return Result(data: activity);
        }
      }

      if (response.statusCode == 400) {
        return Result(
          error: 'Error 400: Este nombre ya está asignado a otra actividad',
          statusCode: response.statusCode,
        );
      }

      return Result(
        error: 'Error al crear Gaps: ${response.statusCode}',
        statusCode: response.statusCode,
      );

    } catch (e) {
      print('Error en createGaps: $e');
      return Result(error: e.toString());
    }
  }

  Future<Result<LinkersActivity>> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Linkers",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['flashcards'] != null && data['linkers'] != null && data['activity'] != null) {
          List<Flashcard> flashcards = (data['flashcards'] as List)
              .asMap()
              .entries
              .where((entry) => entry.key % 3 == 0)
              .map((entry) => Flashcard.fromJson(entry.value))
              .toList();

          List<Linkers> linkers = (data['linkers'] as List)
              .asMap()
              .map((index, linkersJson) => MapEntry(
            index,
            Linkers.fromJson(linkersJson, index),
          ))
              .values
              .toList();

          final activity = LinkersActivity(
            flashcards: flashcards,
            linkers: linkers,
            id: data['activity']['id'],
            name: data['activity']['nombre'],
            quantity: data['activity']['numero_preguntas'],
            timer: data['activity']['tiempo_pregunta'],
            isRated: false,
          );

          return Result(data: activity);
        }
      }

      if (response.statusCode == 400) {
        return Result(
            error: response.body,
            statusCode: response.statusCode
        );
      }

      return Result(
          error: 'Error al crear Linkers: ${response.statusCode}',
          statusCode: response.statusCode
      );
    } catch (e) {
      print('Error en createLinkers: $e');
      return Result(error: e.toString());
    }
  }

  Future<Result<FlashcardActivity>> createFlashCard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/activity/create'),
        body: jsonEncode({
          'tipo_actividad': "Flashcards",
          'tiempo_por_pregunta': activityTimer,
          'numero_preguntas': activityQuantity,
          'nombre': activityName,
          'pdf_url': pdfUrl,
          'usuario': userId,
        }),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(utf8.decode(response.bodyBytes));

        if (data['flashcards'] != null && data['activity'] != null) {
          List<Flashcard> flashcards = (data['flashcards'] as List)
              .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
              .toList();

          final activity = FlashcardActivity(
            id: data['activity']['id'],
            flashcards: flashcards,
            name: data['activity']['nombre'],
            quantity: data['activity']['numero_preguntas'],
            timer: data['activity']['tiempo_pregunta'],
            isRated: false,
          );

          return Result(data: activity);
        }
      }

      if (response.statusCode == 400) {
        return Result(
            error: response.body,
            statusCode: response.statusCode
        );
      }

      return Result(
          error: 'Error al crear Flashcard: ${response.statusCode}',
          statusCode: response.statusCode
      );
    } catch (e) {
      print('Error en createFlashCard: $e');
      return Result(error: e.toString());
    }
  }


  Future<bool> rateActivity(int activityId, int rating, String commentary) async {
    try {
      int userId = await localStorageService.getCurrentUserId();

      final response = await http.post(
        Uri.parse('$baseUrl/rated/create'),
        body: jsonEncode({
          "commentary": commentary,
          "rate": rating,
          "activity": activityId,
          "user": userId
        }),
        headers: headers,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }
      throw Exception('Error al calificar actividad: ${response.statusCode}');
    } catch (e) {
      print('Error en rateActivity: $e');
      return false;
    }
  }

  Future<List<Activity>> getActivityListByUserId(int tabIndex) async {
    try {
      int userId = await localStorageService.getCurrentUserId();
      String url = '$baseUrl/activity/search/$userId';

      if (tabIndex == 1) {
        url += '?favorito=true';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> activitiesList = jsonData['activities'];
        return activitiesList.map((json) => Activity.fromJson(json)).toList();
      }
      throw Exception('Error al cargar actividades: ${response.statusCode}');
    } catch (e) {
      print('Error en getActivityListByUserId: $e');
      throw Exception('Error de conexión: $e');
    }
  }
}