import 'dart:developer';
import 'dart:io';
import 'package:snapverese/model/post_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart';

class PostService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> uploadImageToStorage(File imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${basename(imageFile.path)}';

      await _client.storage.from('post-images').upload(fileName, imageFile);

      final String publicUrl = _client.storage.from('post-images').getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      log("Image upload failed: $e");
      return null;
    }
  }

  /// Add new post to Supabase
  Future<void> addPost(PostModel post) async {
    try{
    await _client.from('posts').insert(post.toMap());
    }catch(e){
      log("Failed to add post: $e");
    }
  }

  /// Fetch all posts from Supabase
Future<List<PostModel>> fetchAllPosts() async {
  try {
    final data = await _client
        .from('posts')
        .select()
        .order('created_at', ascending: false);

    return (data as List).map((map) => PostModel.fromMap(map)).toList();
  } catch (e) {
    log("Failed to fetch posts: $e");
    return []; 
  }
}

  /// Delete post by ID
  Future<void> deletePost(String postId) async { 
    await _client.from('posts').delete().eq('id', postId);
  }

  // Show current users post's
  Future<List<PostModel>> fetchPostByUser(String uid)async{
    final response = await Supabase.instance.client.from('posts').select().eq('uid', uid)
    .order('created_at',ascending: false);
    return (response as List).map((e) => PostModel.fromMap(e)).toList();
  }
}
