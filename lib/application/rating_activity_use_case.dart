import '../domain/repositories/activity_repository.dart';

class RatingActivityUseCase{
  final ActivityRepository activityRepository;

  RatingActivityUseCase(this.activityRepository);

  Future<bool> rateActivity(int activityId, String activityType, int rating, String commentary) async {
    try {
      return await activityRepository.rateActivity(activityId, activityType, rating, commentary);
    } catch (e) {
      return false;
    }
  }

}