import 'package:snapverese/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final _client = Supabase.instance.client;

  Future<AuthResponse> signUp(String email, String password) async {
    return await _client.auth.signUp(email: email, password: password);
  }

  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> storeUserData(UserModel user) async {
  await _client.from('users').insert(user.toMap());
}


  Session? get session => _client.auth.currentSession;
  User? get currentUser => _client.auth.currentUser;
}
