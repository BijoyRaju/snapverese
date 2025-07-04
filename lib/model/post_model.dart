class PostModel {
  final String id;
  final String uid;
  final String caption;
  final String imageUrl;
  final DateTime createdAt;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByCurrentUser; 


  PostModel({
    required this.id,
    required this.uid,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    required this.likesCount,
    required this.commentsCount,
    this.isLikedByCurrentUser = false
  });

  Map<String, dynamic> toMap() {
    final map = {
      'uid': uid,
      'caption': caption,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked_by_current_user' : isLikedByCurrentUser
    };

    if (id.isNotEmpty) {
      map['id'] = id;
    }

    return map;
  }


  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      uid: map['uid'],
      caption: map['caption'],
      imageUrl: map['image_url'],
      createdAt: DateTime.parse(map['created_at']),
      likesCount: map['likes_count'] ?? 0,
      commentsCount: map['comments_count'] ?? 0,
      isLikedByCurrentUser: map['is_liked'] ?? false,
    );
  }
}
