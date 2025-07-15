import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/service/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserController with ChangeNotifier {
  final UserService _userService = UserService();
  List<UserModel> _searchResults = [];
  List<UserModel> _allUsers = [];
  bool _isLoading = false;
  UserModel? _currentUser;
  File? _pickedImage;
  String? _uploadedImageUrl;

  List<UserModel> get searchResults => _searchResults;
  List<UserModel> get allUsers => _allUsers;
  bool get isLoading => _isLoading;
  UserModel? get currentUser => _currentUser;
  File? get pickedImage => _pickedImage;
  String? get uploadedImageUtl => _uploadedImageUrl;
  

  // Fetch all user
  Future<void>fetchAllUser()async{
    _isLoading = true;
    notifyListeners();
    _allUsers = await _userService.getAllUsers();
    _isLoading = false;
    notifyListeners();
  }

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

  // Get user by id
  Future<UserModel?>getUserById(String uid)async{
    try{
      return await _userService.getUserById(uid);
    }catch(e){
      log("Error fetching user : $e");
      return null;
    }
  }

void setPickedImageFile(File? file){
  _pickedImage = file;
  notifyListeners();
}

void uploadedImageUrl(String? url){
  _uploadedImageUrl = url;
  notifyListeners();
}

// Delete profile photo
Future<void> deleteProfilePhoto() async {
  try {
    if (_currentUser == null || (_currentUser!.profileImage?.isEmpty ?? true)) return;

    final imageUrl = _currentUser!.profileImage!;
    final filePath = imageUrl.split('/').last.split('?').first;

    await _userService.deleteProfile(filePath);

    _currentUser = _currentUser!.copyWith(profileImage: '');
    await _userService.updateUser(_currentUser!);

    notifyListeners();
  } catch (e) {
    debugPrint("Error deleting profile photo: $e");
  }
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