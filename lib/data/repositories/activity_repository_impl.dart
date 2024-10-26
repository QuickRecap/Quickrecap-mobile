import 'package:quickrecap/domain/entities/activity.dart';
import 'package:quickrecap/domain/entities/linkers_activity.dart';
import 'package:quickrecap/domain/entities/gaps_activity.dart';
import 'package:quickrecap/domain/entities/quiz_activity.dart';
import 'package:quickrecap/domain/entities/flashcard_activity.dart';
import 'package:quickrecap/domain/repositories/activity_repository.dart';
import '../api/activity_api.dart';

class ActivityRepositoryImpl implements ActivityRepository{

  final ActivityApi activityApi;

  ActivityRepositoryImpl(this.activityApi);

  @override
  Future<FlashcardActivity?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await activityApi.createFlashCard(activityName, activityTimer, activityQuantity, pdfUrl);
  }

  @override
  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await activityApi.createQuiz(activityName, activityTimer, activityQuantity, pdfUrl);
  }

  @override
  Future<LinkersActivity?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await activityApi.createLinkers(activityName, activityTimer, activityQuantity, pdfUrl);
  }

  @override
  Future<bool> rateActivity(int activityId, int rating, String commentary) async {
    return await activityApi.rateActivity(activityId, rating, commentary);
  }

  @override
  Future<List<Activity>> getActivityListByUserId(int tabIndex) async {
    return await activityApi.getActivityListByUserId(tabIndex);
  }

  @override
  Future<GapsActivity?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await activityApi.createGaps(activityName, activityTimer, activityQuantity, pdfUrl);
  }

}