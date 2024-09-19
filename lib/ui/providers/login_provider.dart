import 'package:flutter/foundation.dart';
import 'package:quickrecap/domain/entities/user.dart';
import '../../application/login_use_case.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider(this.loginUseCase);

  Future<User?> login(String email, String password) async {
    return await loginUseCase.login(email, password);
  }
}