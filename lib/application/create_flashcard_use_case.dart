import '../domain/entities/flashcard_activity.dart';
import '../domain/entities/results.dart';
import '../domain/repositories/activity_repository.dart';

class CreateFlashcardUseCase {
  final ActivityRepository activityRepository;

  CreateFlashcardUseCase(this.activityRepository);

  Future<Result<FlashcardActivity>?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      return await activityRepository.createFlashcard(activityName, activityTimer, activityQuantity,pdfUrl);
    } catch (e) {
      return null;
    }
  }
}
