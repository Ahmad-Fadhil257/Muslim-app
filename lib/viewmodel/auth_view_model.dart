import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository);

  User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get errorMessage => _errorMessage;

  /// Initialize - check if user is already logged in
  Future<void> initialize() async {
    _currentUser = _authRepository.getCurrentUser();
    notifyListeners();
  }

  /// Sign up with email and password
  Future<bool> signUp({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.signUp(
        email: email,
        password: password,
      );

      if (result.success && result.user != null) {
        _currentUser = Supabase.instance.client.auth.currentUser;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with email and password
  Future<bool> signIn({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.signIn(
        email: email,
        password: password,
      );

      if (result.success) {
        _currentUser = _authRepository.getCurrentUser();
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.errorMessage;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.signOut();
    _currentUser = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
