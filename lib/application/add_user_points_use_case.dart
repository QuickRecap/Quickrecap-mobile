import '../domain/repositories/user_repository.dart';

class AddUserPointsUseCase{
  final UserRepository userRepository;

  AddUserPointsUseCase(this.userRepository);

  Future<bool> addUserPoints(int points) async {
    try {
      return await userRepository.addUserPoints(points);
    } catch (e) {
      return false;
    }
  }

}