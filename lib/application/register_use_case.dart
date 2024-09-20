import '../domain/entities/user.dart';
import '../domain/repositories/user_repository.dart';

class RegisterUseCase {
  final UserRepository userRepository;

  RegisterUseCase(this.userRepository);

  Future<bool> register(String name, String lastname, String gender, String phone, String email, String password) async {
    try {
      return await userRepository.register(name, lastname, gender, phone, email, password);
    } catch (e) {
      return false;
    }
  }
}
