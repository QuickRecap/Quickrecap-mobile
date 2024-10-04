import 'package:flutter/foundation.dart';
import '../../application/create_flashcard_use_case.dart';
import '../../domain/entities/flashcard.dart';

class FlashcardProvider extends ChangeNotifier {
  final CreateFlashcardUseCase createFlashcardUseCase;

  // Constructor que inicializa el supportUseCase
  FlashcardProvider(this.createFlashcardUseCase);

  Future<List<Flashcard>?> createFlashcard(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await createFlashcardUseCase.createFlashcard(activityName, activityTimer, activityQuantity, pdfUrl);
  }
}