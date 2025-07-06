import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:snapverese/service/like_service.dart';

class LikeController extends ChangeNotifier{
  final LikeService _likeService = LikeService();

  final Set<String> _likedPost = {};
  final Map<String,int> _likesCount = {};

  Set<String> get likedPost => _likedPost;
  Map<String,int> get likesCount => _likesCount;

  Future<void> toggleLike(String postId,String userId)async{
    try{
    final isLiked = _likedPost.contains(postId);
    if(isLiked){
      await _likeService.unLikePost(postId, userId);
      _likedPost.remove(postId);
      _likesCount[postId] = (_likesCount[postId] ?? 1) - 1;
    }else{
      await _likeService.likePost(postId, userId);
      _likedPost.add(postId);
      _likesCount[postId] = (_likesCount[postId] ?? 0) + 1;
    }
    notifyListeners();
  }
  catch(e){
    log("Toggle like failed : $e");
  }
  }

  Future<void> fetchLikesData(String postId,String userId)async{
    final isLiked =  await _likeService.isPostLikedByUser(postId, userId);
    final count = await _likeService.getLikesCount(postId);
    if(isLiked) _likedPost.add(postId);
    _likesCount[postId] = count;
    notifyListeners();
  }
}