import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> login(String email, String password);
  Future<bool> register(String name, String lastname, String gender, String phone, String email, String password);
  Future<bool> changePassword(String userId, String oldPassword, String newPassword);
  Future<bool> editProfile(String userId, String firstName, String lastName, String phone,String gender, String birthdate, String imageUrl);
  Future<bool> addUserPoints(int points, int activityId, int correctAnswers, int totalQuestions);
}
