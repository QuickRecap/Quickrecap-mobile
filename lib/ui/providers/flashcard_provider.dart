import 'package:flutter/foundation.dart';
import '../../application/create_flashcard_use_case.dart';
import '../../domain/entities/flashcard_activity.dart';

class FlashcardProvider extends ChangeNotifier {
  final CreateFlashcardUseCase createFlashcardUseCase;

  // Constructor que inicializa el supportUseCase
  FlashcardProvider(this.createFlashcardUseCase);

  Future<FlashcardActivity?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await createFlashcardUseCase.createFlashcard(activityName, activityTimer, activityQuantity, pdfUrl);
  }
}