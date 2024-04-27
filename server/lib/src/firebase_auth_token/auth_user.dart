import 'string_email_extension.dart';
import 'firebase_auth_token.dart';

export 'sip.dart';

/// Firebase Auth user
class AuthUser {
  final FirebaseAuthToken _token;

  /// Unique user id
  final String id;

  /// The name of the user
  /// which can also be email when not given
  final String name;

  /// Picture url if set
  final String? picture;

  /// The email address of user
  final String email;

  /// Has the email address been verified?
  final bool isEmailVerified;

  /// How did the user authenticate (password/google/apple/...)
  final String signInProvider;

  /// Get a statically typed reference of the sign in provider
  Sip get sip => Sip.fromString(signInProvider);

  /// Time of token generation
  final int iat;

  /// Extract custom claim from the token
  dynamic getCustomClaim(String name) => _token.content[name];

  /// Create your own custom claims object from the raw data in the token
  T getCustomClaims<T>(T Function(Map<String, dynamic> data) creator) {
    return creator(_token.content);
  }

  /// User auth obj constructor
  const AuthUser(
    this._token, {
    required this.id,
    required this.name,
    required this.picture,
    required this.email,
    required this.isEmailVerified,
    required this.signInProvider,
    required this.iat,
  });

  @override
  bool operator ==(Object other) => other is AuthUser && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '''
    AuthUser {
      id: $id,
      name: $name,
      picture: $picture,
      email: $email,
      isEmailVerified: $isEmailVerified,
      signInProvider: $signInProvider,
      iat: $iat,
    }
    ''';
  }

  /// create user from data map
  factory AuthUser.fromToken(FirebaseAuthToken token) {
    return AuthUser(
      token,
      id: token.content['sub']! as String,
      name: token.content['name'] as String? ??
          (token.content['email']! as String).withoutEmailProvider(),
      picture: token.content['picture'] as String?,
      email: token.content['email']! as String,
      isEmailVerified: token.content['email_verified']! as bool,
      signInProvider: token.content['firebase']!['sign_in_provider']! as String,
      iat: token.content['iat']! as int,
    );
  }

  Future<void> verify() {
    return _token.verify();
  }
}
