import 'package:flutter/foundation.dart';
import '../../application/login_use_case.dart';

class LoginProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;

  LoginProvider(this.loginUseCase);

  Future<bool> login(String email, String password) async {
    return await loginUseCase.login(email, password);
  }
}