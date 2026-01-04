import 'app_user.dart';

/// Abstract repository interface for authentication operations.
///
/// This interface defines the contract for auth operations.
/// The data layer provides the concrete implementation (FirebaseAuthRepository).
abstract class AuthRepository {
  /// Stream of auth state changes.
  ///
  /// Emits [AppUser] when signed in, null when signed out.
  Stream<AppUser?> get authStateChanges;

  /// The currently signed-in user, or null if not authenticated.
  AppUser? get currentUser;

  /// Signs in with email and password.
  ///
  /// Returns the [AppUser] on success.
  /// Throws an exception on failure.
  Future<AppUser> signInWithEmailAndPassword(String email, String password);

  /// Creates a new user with email and password.
  ///
  /// Returns the [AppUser] on success.
  /// Throws an exception on failure.
  Future<AppUser> createUserWithEmailAndPassword(String email, String password);

  /// Signs out the current user.
  Future<void> signOut();
}
