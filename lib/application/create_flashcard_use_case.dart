import '../domain/entities/flashcard_activity.dart';
import '../domain/repositories/activity_repository.dart';

class CreateFlashcardUseCase {
  final ActivityRepository activityRepository;

  CreateFlashcardUseCase(this.activityRepository);

  Future<FlashcardActivity?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final FlashcardActivity? flashcardActivity =  await activityRepository.createFlashcard(activityName, activityTimer, activityQuantity,pdfUrl);
      return flashcardActivity;
    } catch (e) {
      return null;
    }
  }
}
