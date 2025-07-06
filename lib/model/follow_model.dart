class FollowModel {
  final String id;
  final String followerUid;
  final String followingUid;
  final DateTime createdAt;

  FollowModel({
    required this.id,
    required this.followerUid,
    required this.followingUid,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'follower_uid': followerUid,
      'following_uid': followingUid,
      'created_at': createdAt.toIso8601String(), 
    };
  }

  factory FollowModel.fromMap(Map<String, dynamic> map) {
    return FollowModel(
      id: map['id'],
      followerUid: map['follower_uid'],
      followingUid: map['following_uid'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
