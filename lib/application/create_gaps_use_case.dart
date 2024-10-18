import '../domain/repositories/activity_repository.dart';
import '../domain/entities/gaps_activity.dart';

class CreateGapsUseCase {
  final ActivityRepository activityRepository;

  CreateGapsUseCase(this.activityRepository);

  Future<GapsActivity?> createGaps(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final GapsActivity? gapsActivity =  await activityRepository.createGaps(activityName, activityTimer, activityQuantity,pdfUrl);
      return gapsActivity;
    } catch (e) {
      return null;
    }
  }
}
