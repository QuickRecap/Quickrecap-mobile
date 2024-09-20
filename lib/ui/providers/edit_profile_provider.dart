import 'package:flutter/foundation.dart';
import '../../application/edit_profile_use_case.dart';

class EditProfileProvider extends ChangeNotifier {
  final EditProfileUseCase editProfileUseCase;

  // Constructor que inicializa el editProfileUseCase
  EditProfileProvider(this.editProfileUseCase);

  // Método para editar el perfil
  Future<bool> editProfile(
      String userId,
      String firstName,
      String lastName,
      String phone,
      String gender,
      String birthdate,
      String imageUrl
  ) async {
    return await editProfileUseCase.editProfile(
      userId,
      firstName,
      lastName,
      phone,
      gender,
      birthdate,
      imageUrl
    );
  }
}
