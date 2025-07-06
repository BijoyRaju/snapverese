import 'dart:developer';

import 'package:supabase_flutter/supabase_flutter.dart';

class LikeService {
  final _client = Supabase.instance.client;

  Future<void> likePost(String postId,String userId)async{
    try{

      log("Trying to like post: postId=$postId, userId=$userId");

      if(postId.isEmpty || userId.isEmpty){
        throw Exception("Invalid post id or user id");
      }

      final response =  await _client.from('likes').insert({
        'post_id' : postId,
        'user_id' : userId
      });
      
      log("Inserted like: $response");
      
    }catch(e){
      log("Error liking post: $e");
      rethrow;
    }
  }

  Future<void> unLikePost(String postId,String userId)async{
    try{
      await _client.from('likes').delete()
        .eq('post_id', postId)
        .eq('user_id', userId);
    }catch(e){
      log("Error unliking post: $e");
    }
  }

  Future<bool> isPostLikedByUser(String postId,String userId)async{
    final result = await _client.from('likes').select()
      .eq('post_id', postId)
      .eq('user_id', userId)
      .maybeSingle();
      return result != null;
  }

  Future<int> getLikesCount(String postId) async {
    final response = await Supabase.instance.client
      .from('likes')
      .select('id')
      .eq('post_id', postId)
      .count(CountOption.exact); 
  return response.count ?? 0;
}

}