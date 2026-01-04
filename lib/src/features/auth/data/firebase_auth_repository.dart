import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

/// Firebase implementation of [AuthRepository].
///
/// Uses FirebaseAuth SDK for authentication operations.
class FirebaseAuthRepository implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository({firebase_auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  /// Maps a Firebase User to our domain AppUser entity.
  AppUser? _mapFirebaseUser(firebase_auth.User? user) {
    if (user == null) return null;
    return AppUser(
      uid: user.uid,
      email: user.email,
      isAnonymous: user.isAnonymous,
    );
  }

  @override
  Stream<AppUser?> get authStateChanges =>
      _firebaseAuth.authStateChanges().map(_mapFirebaseUser);

  @override
  AppUser? get currentUser => _mapFirebaseUser(_firebaseAuth.currentUser);

  @override
  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _mapFirebaseUser(credential.user);
    if (user == null) {
      throw Exception('Sign-in failed: user is null');
    }
    return user;
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = _mapFirebaseUser(credential.user);
    if (user == null) {
      throw Exception('Sign-up failed: user is null');
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
