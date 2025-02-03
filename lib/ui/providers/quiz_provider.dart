import 'package:flutter/foundation.dart';
import '../../application/create_quiz_use_case.dart';
import '../../domain/entities/quiz_activity.dart';
import '../../domain/entities/results.dart';

class QuizProvider extends ChangeNotifier {
  final CreateQuizUseCase createQuizUseCase;

  // Constructor que inicializa el supportUseCase
  QuizProvider(this.createQuizUseCase);

  Future<Result<QuizActivity>?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await createQuizUseCase.createQuiz(activityName, activityTimer, activityQuantity, pdfUrl);
  }
}