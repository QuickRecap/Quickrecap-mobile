import '../domain/repositories/activity_repository.dart';
import '../domain/entities/flashcard.dart';

class CreateFlashcardUseCase {
  final ActivityRepository activityRepository;

  CreateFlashcardUseCase(this.activityRepository);

  Future<List<Flashcard>?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final List<Flashcard>? flashcards =  await activityRepository.createFlashcard(activityName, activityTimer, activityQuantity,pdfUrl);
      return flashcards;
    } catch (e) {
      return null;
    }
  }
}
