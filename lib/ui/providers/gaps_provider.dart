import 'package:flutter/foundation.dart';
import '../../application/create_gaps_use_case.dart';
import '../../domain/entities/gaps_activity.dart';

class GapsProvider extends ChangeNotifier {
  final CreateGapsUseCase createGapsUseCase;

  // Constructor que inicializa el supportUseCase
  GapsProvider(this.createGapsUseCase);

  Future<GapsActivity?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    return await createGapsUseCase.createGaps(activityName, activityTimer, activityQuantity, pdfUrl);
  }
}