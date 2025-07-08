import 'dart:developer';

import 'package:snapverese/model/comment_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CommentService {
  final _client = Supabase.instance.client;

// Add Comment
  Future <void> addComments(CommentModel comment)async{
    try{
    await _client.from('comments').insert(comment);
    }catch(e){
      log("Failed adding comment : $e");
    }
  }


// Show Comments
  Future<List<CommentModel>> getComments(String postId)async{
    try{
    final response =  await _client.from('comments')
      .select()
      .eq('post_id', postId)
      .order('created_at',ascending: false);

    return (response as List).map((e) => CommentModel.fromMap(e)).toList();
    }catch(e){
      log("Failed showing comments : $e");
      return [];
    }
  }


// Delete Comment
  Future<void> deleteComment(String id)async{
    try{
    await _client.from('comments').delete().eq('id', id);
    }catch(e){
      log("Failed deleting comment : $e");
    }
  }

}