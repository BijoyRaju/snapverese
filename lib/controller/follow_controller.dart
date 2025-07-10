import 'package:flutter/material.dart';
import 'package:snapverese/service/follow_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FollowController extends ChangeNotifier {
  final FollowService _followService = FollowService();

  bool _isFollowing = false;
  bool _isLoading = false;
  int _isFollowerCount = 0;
  int _isFollowingCount = 0;

  bool get isFollowing => _isFollowing;
  bool get isLoading => _isLoading;
  int get isFollowerCount => _isFollowerCount;
  int get isFllowingCount => _isFollowingCount;

  Future<void> checkIfFollowing(String currentUid, String otherUid) async {
    _isLoading = true;
    notifyListeners();

    final response = await Supabase.instance.client
        .from('follows')
        .select()
        .eq('follower_uid', currentUid)
        .eq('following_uid', otherUid)
        .maybeSingle();

    _isFollowing = response != null;
    _isLoading = false;
    notifyListeners();
  }


  Future<void> followUser(String currentUid, String otherUid) async {
    _isLoading = true;
    notifyListeners();

    await _followService.followUser(currentUid, otherUid);
    _isFollowing = true;

    await getFollowerCount(otherUid); 
    _isLoading = false;
    notifyListeners();
  }


  Future<void> unFollowUser(String currentUid, String otherUid) async {
    _isLoading = true;
    notifyListeners();

    await _followService.unFollowUser(currentUid, otherUid);
    _isFollowing = false;

    await getFollowerCount(otherUid);
    _isLoading = false;
    notifyListeners();
  }


  Future<void> getFollowerCount(String uid) async {
    _isFollowerCount = await _followService.getfollowersCount(uid);
    _isFollowingCount = await _followService.getfollowingCount(uid);
    notifyListeners();
  }
}
