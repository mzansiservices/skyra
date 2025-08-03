// providers/auth_provider.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

enum AuthStatus { authenticated, unauthenticated, loading }

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.unauthenticated;
  User? _user;

  AuthStatus get status => _status;
  User? get user => _user;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    _status = AuthStatus.loading;
    notifyListeners();

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      _user = user;
      _status =
          user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
      notifyListeners();
    });
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      _user = result.user;
      _status = AuthStatus.authenticated;
      notifyListeners();
      return _user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<User?> registerWithEmailAndPassword(
    String email,
    String password,
    String name,
  ) async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      UserCredential result = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      _user = result.user;
      await _user?.updateDisplayName(name);
      _status = AuthStatus.authenticated;
      notifyListeners();
      return _user;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    _status = AuthStatus.unauthenticated;
    _user = null;
    notifyListeners();
  }
}
