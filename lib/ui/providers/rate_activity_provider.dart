import 'package:flutter/foundation.dart';
import '../../application/rating_activity_use_case.dart';
import '../../domain/entities/quiz_activity.dart';

class RateActivityProvider extends ChangeNotifier {
  final RatingActivityUseCase ratingActivityUseCase;

  // Constructor que inicializa el supportUseCase
  RateActivityProvider(this.ratingActivityUseCase);

  Future<bool> rateActivity(int activityId,String activityType, int rating, String commentary) async {
    return await ratingActivityUseCase.rateActivity(activityId,activityType, rating, commentary);
  }
}