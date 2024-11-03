import 'package:flutter/foundation.dart';
import '../../application/add_user_points_use_case.dart';
import '../../domain/entities/user.dart';

class AddUserPointsProvider extends ChangeNotifier {
  final AddUserPointsUseCase addUserPointsUseCase;

  AddUserPointsProvider(this.addUserPointsUseCase);

  Future<bool> addUserPoints(int points, int activityId, int correctAnswers, int totalQuestions) async {
    return await addUserPointsUseCase.addUserPoints(points, activityId, correctAnswers, totalQuestions);
  }
}