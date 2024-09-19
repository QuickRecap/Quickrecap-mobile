import 'package:quickrecap/domain/repositories/support_repository.dart';
import '../api/support_api.dart';

class SupportRepositoryImpl implements SupportRepository {
  final SupportApi supportApi;

  SupportRepositoryImpl(this.supportApi);

  @override
  Future<bool> reportError(String name, String description) async {
    return await supportApi.reportError(name, description);
  }
}
