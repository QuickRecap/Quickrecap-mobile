import '../domain/repositories/user_repository.dart';

class AddUserPointsUseCase{
  final UserRepository userRepository;

  AddUserPointsUseCase(this.userRepository);

  Future<bool> addUserPoints(int points, int activityId) async {
    try {
      return await userRepository.addUserPoints(points, activityId);
    } catch (e) {
      return false;
    }
  }

}