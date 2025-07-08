import 'package:flutter/material.dart';
import 'package:snapverese/model/comment_model.dart';
import 'package:snapverese/service/comment_service.dart';

class CommentController extends ChangeNotifier{
  final _commentService = CommentService();
  List<CommentModel> _comments = [];

  List<CommentModel> get comments => _comments;

  Future<void> loadComments(String postId)async{
    _comments = await _commentService.getComments(postId);
    notifyListeners();
  }

  Future<void> addComments(CommentModel comment)async{
    await _commentService.addComments(comment);
    await loadComments(comment.postId);
  }

  Future<void> deleteCommets(String postId)async{
    await _commentService.deleteComment(postId);
    await loadComments(postId);
  }
}