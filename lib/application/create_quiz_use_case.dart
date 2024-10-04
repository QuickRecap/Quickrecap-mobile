import '../domain/repositories/activity_repository.dart';
import '../domain/entities/quiz_activity.dart';

class CreateQuizUseCase {
  final ActivityRepository activityRepository;

  CreateQuizUseCase(this.activityRepository);

  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final QuizActivity? quizActivity =  await activityRepository.createQuiz(activityName, activityTimer, activityQuantity,pdfUrl);
      return quizActivity;
    } catch (e) {
      return null;
    }
  }
}
