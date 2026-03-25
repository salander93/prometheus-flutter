import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// Service for Google Sign-In via Firebase.
class GoogleAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Sign in with Google. Returns the Firebase ID token to send to backend.
  /// Returns null if user cancelled or sign-in failed.
  Future<String?> signInWithGoogle() async {
    try {
      // Always sign out first so the account picker is shown
      await _googleSignIn.signOut();
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // User cancelled

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      // Get the Firebase ID token to send to our backend.
      final idToken = await userCredential.user?.getIdToken();
      return idToken;
    } catch (e) {
      log('Google Sign-In failed: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
