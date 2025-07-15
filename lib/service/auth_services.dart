import 'dart:developer';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/view/login_screen/reset_password/reset_password.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {

  final GoogleSignIn googleSignIn = GoogleSignIn(
     clientId: '172988492160-c2qn31v2ifmg46cda2v54afl6opiht75.apps.googleusercontent.com',
  );

  final _client = Supabase.instance.client;

  // Register
  Future<AuthResponse> signUp(String email, String password) async {
    try{
    return await _client.auth.signUp(email: email, password: password);
    }catch(e){
      log("Error in Sign Up : $e");
      rethrow;
    }
  }

  // Login
  Future<AuthResponse> signIn(String email, String password) async {
    try{
    return await _client.auth.signInWithPassword(email: email, password: password);
    }catch(e){
      log("Error in Sign In : $e");
      rethrow;
    }
  }

  // SignOut
  Future<void> signOut() async {
    await googleSignIn.signOut();
    await _client.auth.signOut();
  }


  Future<void> storeUserData(UserModel user) async {
  await _client.from('users').insert(user.toMap());
}


  // Google Sign-in
  Future<String> nativeGoogleSignIn() async {
    try {
      await googleSignIn.signOut();

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in canceled");
      }

      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception("Failed to get ID Token from Google");
      }

      final response = await Supabase.instance.client.auth
          .signInWithIdToken(provider: OAuthProvider.google, idToken: idToken);

      if (response.user != null) {
        log("User signed in: ${response.user!.email}");
        return 'Google authentication successful';
      } else {
        throw Exception('Failed to sign in with Supabase');
      }
    } catch (e) {
      log("Error: $e");
      return 'Google authentication failed';
    }
  }

  // Send OTP to phone number
  Future<void> sendOtp(String phone) async {
    try {
      await _client.auth.signInWithOtp(phone: phone);
      log("OTP sent to $phone");
    } catch (e) {
      log("Error sending OTP: $e");
      rethrow;
    }
  }

  // Verify OTP and login
  Future<AuthResponse> verifyOtp(String phone, String otp) async {
    try {
      final res = await _client.auth.verifyOTP(
        phone: phone,
        token: otp,
        type: OtpType.sms,
      );
      return res;
    } catch (e) {
      log("Error verifying OTP: $e");
      rethrow;
    }
  }

  // Check if user is already registered
  Future<bool> isUserRegistered(String uid) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .eq('uid', uid)
          .maybeSingle();

      return response != null;
    } catch (e) {
      log("Error checking user registration: $e");
      return false;
    }
  }

  // reset Password
  static requestResetPassword(){
    Supabase.instance.client.auth.resetPasswordForEmail('bijoyraju66@gmail.com');
    log("Email Send");
  }

  static configDeepLink(BuildContext context){
    final appLinks = AppLinks();
    appLinks.uriLinkStream.listen((uri) {
      if(uri.host == 'password-reset'){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ResetPassword()));
      }
    });
  }


  static resetPassword(String newPassword){
    Supabase.instance.client.auth.updateUser(UserAttributes(password: newPassword));
  }
  User? get currentUser => _client.auth.currentUser;
}
