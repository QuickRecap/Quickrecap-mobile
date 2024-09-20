import '../domain/repositories/user_repository.dart';

class EditProfileUseCase {
  final UserRepository userRepository;

  // Constructor que inicializa el repositorio
  EditProfileUseCase(this.userRepository);

  // Método para editar el perfil
  Future<bool> editProfile(
      String userId,
      String firstName,
      String lastName,
      String phone,
      String gender,
      String birthdate,
      String imageUrl,
  ) async {
    try {
      return await userRepository.editProfile(
        userId,
        firstName,
        lastName,
        phone,
        gender,
        birthdate,
        imageUrl
      );
    } catch (e) {
      return false;
    }
  }
}
