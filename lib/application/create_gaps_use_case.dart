import '../domain/repositories/activity_repository.dart';
import '../domain/entities/results.dart';
import '../domain/entities/gaps_activity.dart';

class CreateGapsUseCase {
  final ActivityRepository activityRepository;

  CreateGapsUseCase(this.activityRepository);

  Future<Result<GapsActivity>?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      return await activityRepository.createGaps(activityName, activityTimer, activityQuantity,pdfUrl);
    } catch (e) {
      return null;
    }
  }
}
