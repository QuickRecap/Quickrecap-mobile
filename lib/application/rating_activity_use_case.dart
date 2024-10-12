import '../domain/repositories/activity_repository.dart';

class RatingActivityUseCase{
  final ActivityRepository activityRepository;

  RatingActivityUseCase(this.activityRepository);

  Future<bool> rateActivity(int activityId, int rating, String commentary) async {
    try {
      return await activityRepository.rateActivity(activityId, rating, commentary);
    } catch (e) {
      return false;
    }
  }

}