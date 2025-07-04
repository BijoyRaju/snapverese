import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:snapverese/model/post_model.dart';
import 'package:snapverese/service/post_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostController with ChangeNotifier {
  final PostService _postService = PostService();
  final List<PostModel> _posts = [];

  List<PostModel> get posts => _posts;
  bool _isLoading = false;
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
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
      notifyListeners();
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
      notifyListeners();
    }
  }

  /// Delete post
  Future<void> deletePost(String postId) async {
    await _postService.deletePost(postId);
    _posts.removeWhere((post) => post.id == postId);
    notifyListeners();
  }
}
