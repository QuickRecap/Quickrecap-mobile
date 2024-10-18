import 'package:flutter/foundation.dart';
import '../../application/get_activities_for_user_use_case.dart';
import '../../domain/entities/activity.dart';

class GetActivitiesForUserProvider extends ChangeNotifier {
  final GetActivitiesForUserUseCase getActivitiesForUserUseCase;

  // Constructor que inicializa el supportUseCase
  GetActivitiesForUserProvider(this.getActivitiesForUserUseCase);

  Future<List<Activity>?> getActivityListByUserId(int tabIndex) async {
    return await getActivitiesForUserUseCase.getActivityListByUserId(tabIndex);
  }
}
