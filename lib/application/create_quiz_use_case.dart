import '../domain/repositories/activity_repository.dart';
import '../domain/entities/quiz_activity.dart';
import '../domain/entities/results.dart';

class CreateQuizUseCase {
  final ActivityRepository activityRepository;

  CreateQuizUseCase(this.activityRepository);

  Future<Result<QuizActivity>?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      return await activityRepository.createQuiz(activityName, activityTimer, activityQuantity,pdfUrl);
    } catch (e) {
      return null;
    }
  }
}
