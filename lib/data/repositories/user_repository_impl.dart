import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../api/user_api.dart';

class UserRepositoryImpl implements UserRepository {
  final UserApi userApi;

  UserRepositoryImpl(this.userApi);

  @override
  Future<User?> login(String email, String password) async {
    return await userApi.login(email, password);
  }
}
