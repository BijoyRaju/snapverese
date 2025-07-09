import 'dart:developer';
import 'dart:io';

import 'package:snapverese/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserService {
  final _client = Supabase.instance.client;

  Future<List<UserModel>> searchUsers(String query) async {
    try {
      final response = await _client
          .from('users')
          .select()
          .ilike('name', '%$query%'); 

      return (response as List).map((e) => UserModel.fromMap(e)).toList();
    } catch (e) {
      log("Search error: $e");
      return [];
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    final data = await _client
        .from('users')
        .select()
        .eq('uid', uid) 
        .maybeSingle();

    if (data != null) {
      return UserModel.fromMap(data);
    }
    return null;
  }

  Future<void> updateUser(UserModel user)async{
    await _client.from('users').update(user.toMap()).eq('uid', user.uid);
  }

  Future<String?>uploadProfileImage(File file)async{
    try{
      final fileName = 'profile_${DateTime.now().microsecondsSinceEpoch}.jpg';

      await _client.storage.from('profile-images').update(fileName, file);
      return _client.storage.from('profile-images').getPublicUrl(fileName);
    }catch(e){
      log("Upload error : $e");
      return null;
    }
  }

    // Delete profile photo
  Future<void> deleteProfile(String imagePath)async{
    try{
    await Supabase.instance.client.storage.from('profile-images').remove([imagePath]);
    }catch(e){
      log("Failed to delete : $e");
    }
  }

}