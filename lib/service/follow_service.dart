import 'package:supabase_flutter/supabase_flutter.dart';

class FollowService {
  final _client = Supabase.instance.client;

  Future<void> followUser(String followerUid, String followingUid)async{
    await _client.from('follows')
      .insert({
        'follower_uid' : followerUid,
        'following_uid' : followingUid
      });
  }

  Future<void>unFollowUser(String followerUid, String followingUid)async{
    await _client.from('follows')
      .delete()
      .eq('follower_uid', followerUid)
      .eq('following_uid', followingUid);
  }

  Future<bool>isFollowing(String followingUid, String followerUid)async{
    final result = await _client.from('follows')
        .select()
        .eq('follower_uid', followerUid)
        .eq('following_uid', followingUid);
      return result.isNotEmpty;
  }

  Future<int> getfollowersCount(String uid)async{
    final result = 
      await _client.from('follows')
        .select().eq('following_uid', uid);
    return result.length;
  }

  Future<int> getfollowingCount(String uid)async{
    final result = 
      await _client.from('follows')
        .select().eq('follower_uid', uid);
    return result.length;
  }
}