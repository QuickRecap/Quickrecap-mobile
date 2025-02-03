import '../entities/quiz_activity.dart';
import '../entities/gaps_activity.dart';
import '../entities/flashcard_activity.dart';
import '../entities/linkers_activity.dart';
import '../entities/activity.dart';
import '../entities/results.dart';


abstract class ActivityRepository {
  Future<Result<QuizActivity>?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<Result<FlashcardActivity>?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<Result<LinkersActivity>?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
  Future<bool> rateActivity(int activityId, int rating, String commentary);
  Future<List<Activity>> getActivityListByUserId(int tabIndex);
  Future<Result<GapsActivity>?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl);
}
