import '../domain/repositories/user_repository.dart';

class AddUserPointsUseCase{
  final UserRepository userRepository;

  AddUserPointsUseCase(this.userRepository);

  Future<bool> addUserPoints(int points, int activityId, int correctAnswers, int totalQuestions) async {
    try {
      return await userRepository.addUserPoints(points, activityId, correctAnswers, totalQuestions);
    } catch (e) {
      return false;
    }
  }

}