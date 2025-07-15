import 'package:flutter/material.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/service/auth_services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthController with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    await _authService.signIn(email, password);
    setLoading(false);
  }

  Future<void> register({
  required String name,
  required String email,
  required String phone,
  required String password,
  required String profileImageUrl, 
}) async {
  setLoading(true);
  try {
    final res = await _authService.signUp(email, password);
    final user = res.user;

    if (user != null) {
      final newUser = UserModel(
        uid: user.id,
        name: name,
        email: email,
        phone: phone,
        profileImage: null,
      );
      await _authService.storeUserData(newUser);
    }
  } catch (e) {
    rethrow;
  } finally {
    setLoading(false);
  }
}

// Send OTP
Future<void> sendOtp(String phone) async {
    setLoading(true);
    await _authService.sendOtp(phone);
    setLoading(false);
  }

  // Verify OTP and return AuthResponse
  Future<AuthResponse> verifyPhoneOtp(String phone, String otp) async {
    setLoading(true);
    final res = await _authService.verifyOtp(phone, otp);
    setLoading(false);
    return res;
  }

  // Register phone user
  Future<void> registerPhoneUser({
    required String name,
    required String phone,
  }) async {
    final user = _authService.currentUser;
    if (user == null) throw Exception("User not authenticated");

    final newUser = UserModel(
      uid: user.id,
      name: name,
      email: '',
      phone: phone,
      profileImage: null,
    );

    await _authService.storeUserData(newUser);
  }

  // Check registration status
  Future<bool> checkIfRegistered() async {
    final user = _authService.currentUser;
    if (user == null) return false;
    return await _authService.isUserRegistered(user.id);
  }
  

  void logout() {
    _authService.signOut();
  }

  Future<void> signOut() async {}
}
