import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snapverese/service/follow_service.dart';

class FollowController extends ChangeNotifier{
  final FollowService _followService = FollowService();
  bool _isFollowing = false;
  bool get isFollowing => _isFollowing;

  Future<void> checkIfFollowing(String currentUid, String otherUid)async{
    _isFollowing = await _followService.isFollowing(currentUid, otherUid);
    notifyListeners();
  }

  Future<void> followUser(String currentUid,String otherUid)async{
    await _followService.followUser(currentUid, otherUid);
    _isFollowing = true;
    notifyListeners();
  }

  Future<void> unFollowUser(String currentUid,String otherUid)async{
    await _followService.unFollowUser(currentUid, otherUid);
    _isFollowing = false;
    notifyListeners();
  }

  Future<int>getFollowerCount(String uid)async{
    return await _followService.getfollowersCount(uid);
  }

  Future<int>getFollowingCount(String uid)async{
    return await _followService.getfollowingCount(uid);
  }
}