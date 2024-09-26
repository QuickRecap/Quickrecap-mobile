import 'package:flutter/foundation.dart';
import '../../application/register_use_case.dart';

class RegisterProvider extends ChangeNotifier {
  final RegisterUseCase registerUseCase;

  // Constructor que inicializa el registerUseCase
  RegisterProvider(this.registerUseCase);

  Future<bool> register(String name, String lastname, String gender, String phone, String email, String password) async {
    return await registerUseCase.register(name, lastname, gender, phone, email, password);
  }
}
