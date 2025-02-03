import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../../domain/entities/flashcard.dart';
import '../../../../domain/entities/flashcard_activity.dart';
import '../../../../domain/entities/quiz.dart';
import '../../../../domain/entities/quiz_activity.dart';
import '../../../../domain/entities/gaps.dart';
import '../../../../domain/entities/gaps_activity.dart';
import '../../../../domain/entities/linkers.dart';
import '../../../../domain/entities/linkers_activity.dart';
import '../../../../domain/entities/quiz_activity.dart';
import 'quiz/play_quiz_activity.dart';
import 'gaps/play_gaps_activity.dart';
import 'linkers/play_linkers_activity.dart';
import 'flashcards/play_flashcards.dart';
import '../home/widgets/loading_activity_dialog.dart';

Future<void> playActivity(BuildContext context, int activityId) async {
  dynamic activityData;

  // Mostrar el diálogo de carga
  await LoadingActivityDialog.show(context);

  try {
    final response = await http.get(
      Uri.parse('https://quickrecap.rj.r.appspot.com/quickrecap/activity/research?id=$activityId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      String tipoActividad = data['actividad']['tipo_actividad'];

      switch (tipoActividad) {
        case 'Quiz':
          if (data['flashcards'] != null && data['quiz'] != null && data['actividad'] != null) {
            List<Flashcard> flashcards = (data['flashcards'] as List)
                .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
                .toList();

            List<Quiz> quizzes = (data['quiz'] as List)
                .map((quizJson) => Quiz.fromJson(quizJson))
                .toList();

            activityData = QuizActivity(
              flashcards: flashcards,
              quizzes: quizzes,
              id: data['actividad']['id'],
              name: data['actividad']['nombre'],
              quantity: data['actividad']['numero_preguntas'],
              timer: data['actividad']['tiempo_por_pregunta'],
              isRated: false,
            );

            if (activityData != null) {
              // Cerrar el diálogo antes de navegar
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayQuizActivity(quizActivity: activityData),
                ),
              );
            }
          }
          break;

        case 'Gaps':
          if (data['flashcards'] != null && data['gaps'] != null && data['actividad'] != null) {
            List<Flashcard> flashcards = (data['flashcards'] as List)
                .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
                .toList();

            List<Gaps> gaps = (data['gaps'] as List)
                .map((gapsJson) => Gaps.fromJson(gapsJson))
                .toList();

            activityData = GapsActivity(
              flashcards: flashcards,
              gaps: gaps,
              id: data['actividad']['id'],
              name: data['actividad']['nombre'],
              quantity: data['actividad']['numero_preguntas'],
              timer: data['actividad']['tiempo_por_pregunta'],
              isRated: false,
            );

            if (activityData != null) {
              // Cerrar el diálogo antes de navegar
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayGapsActivity(gapsActivity: activityData),
                ),
              );
            }
          }
          break;

        case 'Linkers':
          if (data['flashcards'] != null && data['linkers'] != null && data['actividad'] != null) {
            List<Flashcard> flashcards = (data['flashcards'] as List)
                .asMap()
                .entries
                .where((entry) => entry.key % 3 == 0)
                .map((entry) => Flashcard.fromJson(entry.value))
                .toList();

            List<Linkers> linkers = (data['linkers'] as List)
                .asMap()
                .map((index, linkersJson) => MapEntry(index, Linkers.fromJson(linkersJson, index)))
                .values
                .toList();

            activityData = LinkersActivity(
              flashcards: flashcards,
              linkers: linkers,
              id: data['actividad']['id'],
              name: data['actividad']['nombre'],
              quantity: data['actividad']['numero_preguntas'],
              timer: data['actividad']['tiempo_por_pregunta'],
              isRated: false,
            );

            if (activityData != null) {
              // Cerrar el diálogo antes de navegar
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayLinkersActivity(linkersActivity: activityData),
                ),
              );
            }
          }
          break;

        case 'Flashcards':
          if (data['flashcards'] != null) {
            List<Flashcard> flashcards = (data['flashcards'] as List)
                .map((flashcardJson) => Flashcard.fromJson(flashcardJson))
                .toList();

            activityData = FlashcardActivity(
              id: data['actividad']['id'],
              flashcards: flashcards,
              name: data['actividad']['nombre'],
              quantity: data['actividad']['numero_preguntas'],
              timer: data['actividad']['tiempo_por_pregunta'],
              isRated: false,
            );

            if (activityData != null) {
              // Cerrar el diálogo antes de navegar
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlayFlashcards(
                    flashcardActivity: activityData,
                    isPreparation: false,
                  ),
                ),
              );
            }
          }
          break;

        default:
        // Cerrar el diálogo si hay un tipo desconocido
          Navigator.pop(context);
          print('Tipo de actividad desconocido');
          activityData = null;
      }
    } else {
      // Cerrar el diálogo si hay error de respuesta
      Navigator.pop(context);
      print('Error: ${response.statusCode}');
    }
  } catch (e) {
    // Cerrar el diálogo si hay una excepción
    Navigator.pop(context);
    print('Error fetching activities: $e');
  }
}