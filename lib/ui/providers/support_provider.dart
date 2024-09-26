import 'package:flutter/foundation.dart';
import '../../application/support_use_case.dart';

class SupportProvider extends ChangeNotifier {
  final SupportUseCase supportUseCase;

  // Constructor que inicializa el supportUseCase
  SupportProvider(this.supportUseCase);

  Future<bool> reportError(String name, String description) async {
    return await supportUseCase.reportError(name, description);
  }
}
