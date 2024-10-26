import '../domain/repositories/user_repository.dart';

class PasswordUseCase {
  final UserRepository userRepository;

  PasswordUseCase(this.userRepository);

  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    try {
      return await userRepository.changePassword(userId, oldPassword, newPassword);
    } catch (e) {
      return false;
    }
  }
}
