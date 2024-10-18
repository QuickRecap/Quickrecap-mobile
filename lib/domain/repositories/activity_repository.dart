import '../entities/quiz_activity.dart';
import '../entities/gaps_activity.dart';
import '../entities/flashcard_activity.dart';
import '../entities/activity.dart';
import '../entities/flashcard.dart';


abstract class ActivityRepository {
  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<FlashcardActivity?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<bool> rateActivity(int activityId, int rating, String commentary);
  Future<List<Activity>> getActivityListByUserId(int tabIndex);
  Future<GapsActivity?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
}
