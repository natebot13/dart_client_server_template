import 'auth_user.dart';
import 'public_key/service.dart';
import 'package:jose_plus/jose.dart';

export 'auth_user.dart';

/// Firebase Auth Token class for verifying id tokens
/// by providing the unique project id
class FirebaseAuthToken {
  final Service _service;
  final String _projectId;
  final int _timeDiscrepancyInSeconds;
  final JsonWebSignature _jsonWebSignature;
  Map<String, dynamic> content;

  String? get algorithm => _jsonWebSignature.commonProtectedHeader.algorithm;
  String? get keyId => _jsonWebSignature.commonProtectedHeader.keyId;

  int? get expiration => content['exp'];
  int? get issuedAtTime => content['iat'];
  String? get audience => content['aud'];
  String? get issuer => content['iss'];
  String? get subject => content['sub'];
  int? get authTime => content['auth_time'];

  FirebaseAuthToken._({
    required Service service,
    required String projectId,
    required int timeDiscrepancyInSeconds,
    required JsonWebSignature jsonWebSignature,
  })  : _service = service,
        _projectId = projectId,
        _timeDiscrepancyInSeconds = timeDiscrepancyInSeconds,
        _jsonWebSignature = jsonWebSignature,
        content = jsonWebSignature.unverifiedPayload.jsonContent
            as Map<String, dynamic>;

  /// Create instance for firebase id token check by projectId
  static Future<FirebaseAuthToken> fromTokenString({
    required Service service,
    required String projectId,
    int timeDiscrepancyInSeconds = 60,
    required String token,
  }) async {
    final jws = JsonWebSignature.fromCompactSerialization(token);

    return FirebaseAuthToken._(
      service: service,
      projectId: projectId,
      timeDiscrepancyInSeconds: timeDiscrepancyInSeconds,
      jsonWebSignature: jws,
    );
  }

  /// Verify and extract the user object within the id token
  static Future<AuthUser> getUserFromTokenString({
    required Service service,
    required String projectId,
    required String tokenString,
  }) async {
    final token = await fromTokenString(
      service: service,
      projectId: projectId,
      token: tokenString,
    );
    return AuthUser.fromToken(token);
  }

  Future<void> verify() async {
    // Verify the token's payload conforms to the following constraints:
    if (algorithm != 'RS256') {
      throw Exception('Algorithm incorrect');
    }

    final now = DateTime.now().toUtc().millisecondsSinceEpoch / 1000;

    if (expiration == null || expiration! < now) {
      throw Exception('Token is expired');
    }
    // iat	Issued-at time	Must be in the past. The time is measured in seconds since the UNIX epoch.
    if (issuedAtTime == null ||
        issuedAtTime! > now + _timeDiscrepancyInSeconds) {
      throw Exception('Token is not issued in the past');
    }

    // aud	Audience	Must be your Firebase project ID, the unique identifier for your Firebase project, which can be found in the URL of that project's console.
    if (audience != _projectId) {
      throw Exception('Token project id does not correspond');
    }

    // iss	Issuer	Must be "https://securetoken.google.com/<projectId>", where <projectId> is the same project ID used for aud above.
    if (issuer != 'https://securetoken.google.com/$_projectId') {
      throw Exception('Token issuer is not valid');
    }

    // sub	Subject	Must be a non-empty string and must be the uid of the user or device.
    if (subject == null || subject!.isEmpty) {
      throw Exception('Token subject is not found');
    }

    // auth_time	Authentication time	Must be in the past. The time when the user authenticated.
    if (authTime == null || authTime! > now + _timeDiscrepancyInSeconds) {
      throw Exception('Token is not authorized in the past');
    }

    final key = (await _service.getPublicKeys()).keys[keyId];
    if (key == null) {
      throw Exception('Key ID is not found');
    }

    // Finally, ensure that the ID token was signed by the private key corresponding to the token's kid claim.
    final jwk = JsonWebKey.fromPem(key, keyId: keyId);
    final keyStore = JsonWebKeyStore()..addKey(jwk);

    // verify the signature
    final verified = await _jsonWebSignature.verify(keyStore);
    if (verified != true) {
      throw Exception('Token signature verification failed');
    }
  }
}
