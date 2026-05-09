import '../data/user_dao.dart';
import '../models/user.dart';

class UserRepository {
  final UserDao _userDao = UserDao();

  Future<void> register(User user) async {
    await _userDao.insert(user);
  }

  Future<User?> login(String email, String password) async {
    return await _userDao.login(email, password);
  }
}