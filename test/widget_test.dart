// Basic widget test for Not Defterim app.
//
// Tests auth-related functionality with mocked repositories.

import 'package:flutter_test/flutter_test.dart';

import 'package:not_defterim/src/features/auth/domain/app_user.dart';
import 'package:not_defterim/src/features/auth/domain/auth_repository.dart';

/// Mock implementation of [AuthRepository] for testing.
class MockAuthRepository implements AuthRepository {
  final AppUser? _mockUser;
  
  MockAuthRepository({AppUser? mockUser}) : _mockUser = mockUser;

  @override
  Stream<AppUser?> get authStateChanges => Stream.value(_mockUser);

  @override
  AppUser? get currentUser => _mockUser;

  @override
  Future<AppUser> signInWithEmailAndPassword(String email, String password) async {
    if (email == 'test@example.com' && password == 'password123') {
      return const AppUser(uid: 'test-uid', email: 'test@example.com', isAnonymous: false);
    }
    throw Exception('Invalid credentials');
  }

  @override
  Future<AppUser> createUserWithEmailAndPassword(String email, String password) async {
    return AppUser(uid: 'new-uid', email: email, isAnonymous: false);
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('AppUser', () {
    test('creates user with required properties', () {
      const user = AppUser(
        uid: 'test-uid',
        email: 'test@example.com',
        isAnonymous: false,
      );

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.isAnonymous, false);
    });

    test('creates anonymous user without email', () {
      const user = AppUser(
        uid: 'anon-uid',
        email: null,
        isAnonymous: true,
      );

      expect(user.uid, 'anon-uid');
      expect(user.email, isNull);
      expect(user.isAnonymous, true);
    });

    test('equality works correctly', () {
      const user1 = AppUser(uid: 'uid', email: 'a@b.com', isAnonymous: false);
      const user2 = AppUser(uid: 'uid', email: 'a@b.com', isAnonymous: false);
      const user3 = AppUser(uid: 'different', email: 'a@b.com', isAnonymous: false);

      expect(user1, equals(user2));
      expect(user1, isNot(equals(user3)));
    });
  });

  group('MockAuthRepository', () {
    test('signInWithEmailAndPassword returns user with valid credentials', () async {
      final repo = MockAuthRepository();
      final user = await repo.signInWithEmailAndPassword('test@example.com', 'password123');

      expect(user.uid, 'test-uid');
      expect(user.email, 'test@example.com');
      expect(user.isAnonymous, false);
    });

    test('signInWithEmailAndPassword throws on invalid credentials', () async {
      final repo = MockAuthRepository();
      
      expect(
        () => repo.signInWithEmailAndPassword('wrong@email.com', 'wrongpass'),
        throwsException,
      );
    });

    test('createUserWithEmailAndPassword returns new user', () async {
      final repo = MockAuthRepository();
      final user = await repo.createUserWithEmailAndPassword('new@user.com', 'newpass123');

      expect(user.uid, 'new-uid');
      expect(user.email, 'new@user.com');
      expect(user.isAnonymous, false);
    });

    test('authStateChanges emits mock user', () async {
      const mockUser = AppUser(uid: 'mock', email: 'mock@test.com', isAnonymous: false);
      final repo = MockAuthRepository(mockUser: mockUser);

      final user = await repo.authStateChanges.first;
      expect(user, equals(mockUser));
    });
  });
}
