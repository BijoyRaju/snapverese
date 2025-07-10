import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snapverese/model/post_model.dart';
import 'package:snapverese/service/post_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostController with ChangeNotifier {
  final PostService _postService = PostService();

  final List<PostModel> _posts = [];
  final List<PostModel> _userPost = [];
  bool _isLoading = false;
  File? _selectedImage;

  File? get selectedImage => _selectedImage;
  List<PostModel> get posts => _posts;
  List<PostModel> get userPost => _userPost;
  bool get isLoading => _isLoading;


  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Create post: upload image + save post
  Future<void> createPost({
    required File imageFile,
    required String caption,
  }) async {
    setLoading(true);
    try {
      final imageUrl = await _postService.uploadImageToStorage(imageFile);
      if (imageUrl == null) throw 'Image upload failed';

      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) throw 'User not logged in';

      final post = PostModel(
        id: '',
        uid: userId,
        caption: caption,
        imageUrl: imageUrl,
        createdAt: DateTime.now(),
        likesCount: 0,
        commentsCount: 0,
      );

      await _postService.addPost(post);
      _posts.insert(0, post);
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }

  // Load all posts from DB
  Future<void> loadPosts() async {
    setLoading(true);
    try {
      final data = await _postService.fetchAllPosts();
      _posts
        ..clear()
        ..addAll(data);
    } catch (e) {
      log("Load posts error: $e");
    } finally {
      setLoading(false);
    }
  }

  Future<void> fetchUserPost(String uid)async{
    setLoading(true);
    try{
      final data = await _postService.fetchPostByUser(uid);
      _userPost..clear()..addAll(data);
    }catch(e){
      log("Error fetching the user post: $e");
    }finally{
      setLoading(false);
    }
  }

  /// Delete post
  Future<void> deletePost(String postId,String uid) async {
    await _postService.deletePost(postId);
    await fetchUserPost(uid);
  }

  // Update Image
  void updateImage(File image){
    _selectedImage = image;
    notifyListeners();
  }


  // Get Post by User
    // Future<List<PostModel>>getUserPost(String uid)async{
    //   try{
    //     return await _postService.fetchPostByUser(uid);
    //   }catch(e){
    //     log("User post fetch error : $e");
    //     return [];
    //   }
    // }
}
