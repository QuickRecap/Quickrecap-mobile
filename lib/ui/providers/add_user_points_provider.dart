import 'package:flutter/foundation.dart';
import '../../application/add_user_points_use_case.dart';
import '../../domain/entities/user.dart';

class AddUserPointsProvider extends ChangeNotifier {
  final AddUserPointsUseCase addUserPointsUseCase;

  AddUserPointsProvider(this.addUserPointsUseCase);

  Future<bool> addUserPoints(int points) async {
    return await addUserPointsUseCase.addUserPoints(points);
  }
}