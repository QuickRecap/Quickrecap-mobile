import '../domain/repositories/activity_repository.dart';
import '../domain/entities/activity.dart';

class GetActivitiesForUserUseCase {
  final ActivityRepository activityRepository;

  GetActivitiesForUserUseCase(this.activityRepository);

  Future<List<Activity>?> getActivityListByUserId(int tabIndex) async {
    try {
      return await activityRepository.getActivityListByUserId(tabIndex);
    } catch (e) {
      return null;
    }
  }
}
