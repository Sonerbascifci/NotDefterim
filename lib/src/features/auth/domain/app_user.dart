/// Represents an authenticated user in the application.
///
/// This is a domain entity that abstracts the underlying auth provider (Firebase).
/// All fields are immutable.
class AppUser {
  /// Unique identifier for the user (Firebase UID).
  final String uid;

  /// User's email address. Null for anonymous users.
  final String? email;

  /// Whether this user is signed in anonymously.
  final bool isAnonymous;

  const AppUser({
    required this.uid,
    this.email,
    required this.isAnonymous,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          isAnonymous == other.isAnonymous;

  @override
  int get hashCode => uid.hashCode ^ email.hashCode ^ isAnonymous.hashCode;

  @override
  String toString() =>
      'AppUser(uid: $uid, email: $email, isAnonymous: $isAnonymous)';
}
