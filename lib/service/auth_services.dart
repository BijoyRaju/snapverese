import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId: '864232459547-r7m5v8ee44mv2f8sv7kqf4gao2atge0d.apps.googleusercontent.com',
  );

  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _client.auth.signOut();
  }

  Future<void> storeUserData(UserModel user) async {
  await _client.from('users').insert(user.toMap());
}


  Session? get session => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;



  Future<String> nativeGoogleSignIn() async {
    try {
      await googleSignIn.signOut();
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception("Google sign-in cancelled");

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      if (idToken == null) throw Exception("Failed to get ID token");

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
      );

      if (response.user != null) {
        log("User signed in: ${response.user!.email}");
        return "Google Authentication successful";
      }
      throw Exception("Failed to sign in with Google");
    } catch (e) {
      log("Google auth error: $e");
      return "Google authentication failed";
    }
  }
}
