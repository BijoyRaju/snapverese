import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:snapverese/service/like_service.dart';

class LikeController extends ChangeNotifier{
  final LikeService _likeService = LikeService();

  final Set<String> _likedPost = {};
  final Map<String,int> _likesCount = {};
  final Map<String,Set<String>> _userLikedPost = {};

  Set<String> get likedPost => _likedPost;
  Map<String,int> get likesCount => _likesCount;
  Map<String,Set<String>> get userLikedPost => _userLikedPost;


Future<void> toggleLike(String postId, String userId) async {
  try {
    final isLiked = isLikedByUser(postId, userId);

    if (isLiked) {
      // Unlike
      await _likeService.unLikePost(postId, userId);
      _userLikedPost[userId]?.remove(postId);

      // Prevent negative count
      final currentCount = _likesCount[postId] ?? 1;
      _likesCount[postId] = currentCount > 0 ? currentCount - 1 : 0;
    } else {
      // Like
      await _likeService.likePost(postId, userId);
      _userLikedPost.putIfAbsent(userId, () => {}).add(postId);
      _likesCount[postId] = (_likesCount[postId] ?? 0) + 1;
    }

    notifyListeners();
  } catch (e) {
    log("Toggle like failed : $e");
  }
}

  Future<void> fetchLikesData(String postId,String userId)async{
    final isLiked =  await _likeService.isPostLikedByUser(postId, userId);
    final count = await _likeService.getLikesCount(postId);
    final userLikes = _userLikedPost[userId] ?? {};
    if(isLiked) userLikes.add(postId);
    _userLikedPost[userId] = userLikes;
    _likesCount[postId] = count;
    notifyListeners();
  }

  bool isLikedByUser(String postId, String userId){
    return _userLikedPost[userId]?.contains(postId) ?? false;
  }
}