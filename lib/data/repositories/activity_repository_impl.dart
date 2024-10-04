import 'package:quickrecap/domain/entities/flashcard.dart';
import 'package:quickrecap/domain/entities/quiz_activity.dart';
import 'package:quickrecap/domain/repositories/activity_repository.dart';
import '../api/activity_api.dart';

class ActivityRepositoryImpl implements ActivityRepository{

  final ActivityApi activityApi;

  ActivityRepositoryImpl(this.activityApi);

  @override
  Future<Flashcard?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) {
    // TODO: implement createFlashcard
    throw UnimplementedError();
  }

  @override
  Future<QuizActivity?> createQuiz(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await activityApi.createQuiz(activityName, activityTimer, activityQuantity, pdfUrl);
  }

}