import '../domain/entities/linkers_activity.dart';
import '../domain/repositories/activity_repository.dart';
import '../domain/entities/linkers_activity.dart';

class CreateLinkersUseCase {
  final ActivityRepository activityRepository;

  CreateLinkersUseCase(this.activityRepository);

  Future<LinkersActivity?> createLinkers(String activityName, int activityTimer, int activityQuantity, String pdfUrl) async {
    try {
      final LinkersActivity? linkersActivity =  await activityRepository.createLinkers(activityName, activityTimer, activityQuantity,pdfUrl);
      return linkersActivity;
    } catch (e) {
      return null;
    }
  }
}
