import '../entities/quiz_activity.dart';
import '../entities/flashcard_activity.dart';
import '../entities/flashcard.dart';


abstract class ActivityRepository {
  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<FlashcardActivity?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<bool> rateActivity(int activityId, String activityType, int rating, String commentary);
}
