import 'dart:io';

import 'package:flutter/material.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController with ChangeNotifier {
  final UserService _userService = UserService();
  List<UserModel> _searchResults = [];
  bool _isLoading = false;
  UserModel? _currentUser;
  List<UserModel> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;

  // Fetch User
  Future<void>fetchCurrentUser()async{
    _isLoading = true;
    notifyListeners();

    final uid = Supabase.instance.client.auth.currentUser?.id;
    if(uid != null){
      _currentUser = await _userService.getUserById(uid);
    }
    _isLoading = false;
    notifyListeners();
  }


  // Update User Edit profile
  Future<void>updateUserProfile(UserModel user)async{
     _isLoading = true;
     notifyListeners();

     await _userService.updateUser(user);
     _currentUser = user;

     _isLoading = false;
     notifyListeners();
  }


  // Update profile photo
  Future<String?>uploadProfileImage(File imageFile)async{
    return await _userService.uploadProfileImage(imageFile);
  } 


  // Search User
  Future<void> searchUsers(String query) async {
    _isLoading = true;
    notifyListeners();

    _searchResults = await _userService.searchUsers(query);

    _isLoading = false;
    notifyListeners();
  }

  void clearSearch() {
    _searchResults.clear();
    notifyListeners();
  }

}
