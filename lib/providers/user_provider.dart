import 'package:flutter/material.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class UserProvider extends ChangeNotifier {
  final UserRepository _repository = UserRepository();

  User? _currentUser;
  User? get currentUser => _currentUser;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final user = await _repository.login(email, password);

    _isLoading = false;

    if (user != null) {
      _currentUser = user;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Email / Password salah';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    final newUser = User(name: name, email: email, password: password);
    await _repository.register(newUser);

    final loginUser = await _repository.login(email, password);

    _isLoading = false;

    if (loginUser != null) {
      _currentUser = loginUser;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Gagal ambil user';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}