class LikeModel {
  final String id;
  final String userId;
  final String postId;
  final String createdAt;

  LikeModel({
    required this.id,
    required this.userId,
    required this.postId,
    required this.createdAt
  });

  factory LikeModel.fromMap(Map<String,dynamic>map){
    return LikeModel(
      id: map['id'],
      userId: map['user_id'],
      postId: map['post_id'],
      createdAt: map['created_at']
    );
  }

  Map<String,dynamic>toMap(){
    return {
      'user_id' : userId,
      'post_id' : postId
    };
  }
}