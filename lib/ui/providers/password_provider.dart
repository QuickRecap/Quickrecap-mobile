import 'package:flutter/foundation.dart';
import '../../application/password_use_case.dart';
import '../../domain/entities/user.dart';

class PasswordProvider extends ChangeNotifier {
  final PasswordUseCase passwordUseCase;

  PasswordProvider(this.passwordUseCase);

  Future<bool> changePassword(String userId, String oldPassword, String newPassword) async {
    return await passwordUseCase.changePassword(userId, oldPassword, newPassword);
  }
}