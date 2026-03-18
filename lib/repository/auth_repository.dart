import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/user_model.dart';
import '../supabase/supabase_config.dart';

class AuthRepository {
  final SupabaseClient _client = SupabaseConfig.client;

  /// Get the current authenticated user
  User? getCurrentUser() {
    return _client.auth.currentUser;
  }

  /// Check if user is logged in
  bool isLoggedIn() {
    return _client.auth.currentSession != null;
  }

  /// Sign up with email and password
  Future<AuthResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        password: password,
        email: email,
      );

      if (response.user != null) {
        return AuthResult(
          success: true,
          user: UserModel(
            id: response.user!.id,
            email: response.user!.email ?? email,
            createdAt: DateTime.tryParse(response.user!.createdAt),
          ),
        );
      }

      return AuthResult(
        success: false,
        errorMessage: 'Registration failed. Please try again.',
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Sign in with email and password
  Future<AuthResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        password: password,
        email: email,
      );

      if (response.user != null) {
        return AuthResult(
          success: true,
          user: UserModel(
            id: response.user!.id,
            email: response.user!.email ?? email,
            createdAt: DateTime.tryParse(response.user!.createdAt),
          ),
        );
      }

      return AuthResult(
        success: false,
        errorMessage: 'Login failed. Please try again.',
      );
    } on AuthException catch (e) {
      return AuthResult(success: false, errorMessage: e.message);
    } catch (e) {
      return AuthResult(
        success: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _client.auth.signOut();
  }
}

/// Result class for authentication operations
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? errorMessage;

  AuthResult({required this.success, this.user, this.errorMessage});
}
