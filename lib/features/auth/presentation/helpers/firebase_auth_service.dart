import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  FirebaseAuthService._();

  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future<({String? idToken, String? email, String? displayName})?>
  signInWithGoogle() async {
    if (kIsWeb) {
      throw UnsupportedError(
        'Đăng nhập Google hiện chỉ được cấu hình cho Android.',
      );
    }

    try {
      final userCredential = await _auth.signInWithProvider(
        GoogleAuthProvider(),
      );

      final user = userCredential.user;
      if (user == null) {
        return null;
      }

      final idToken = await user.getIdToken();
      return (
        idToken: idToken,
        email: user.email,
        displayName: user.displayName,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'canceled' || error.code == 'web-context-canceled') {
        return null;
      }
      if (error.message != null &&
          error.message!.contains('missing initial state')) {
        return null;
      }
      rethrow;
    }
  }
}
