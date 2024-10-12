import '../domain/repositories/support_repository.dart';

class SupportUseCase {
  final SupportRepository supportRepository;

  SupportUseCase(this.supportRepository);

  Future<bool> reportError(String name, String description) async {
    try {
      return await supportRepository.reportError(name, description);
    } catch (e) {
      return false;
    }
  }
}
