import 'package:flutter/foundation.dart';

/// Simple in-memory (demo) authentication.
/// Replace [login] with a real API / Firebase call when you have a backend.
class AuthService extends ChangeNotifier {
  String? _email;

  String? get email => _email;
  bool get isLoggedIn => _email != null;

  Future<String?> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 800)); // fake network
    // Demo rule: any valid email + password of 6+ characters is accepted.
    if (password.length < 6) {
      return 'Invalid email or password';
    }
    _email = email.trim().toLowerCase();
    notifyListeners();
    return null; // null = success, otherwise an error message
  }

  void logout() {
    _email = null;
    notifyListeners();
  }
}
