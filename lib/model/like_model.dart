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
      userId: map['userId'],
      postId: map['postId'],
      createdAt: map['createdAt']
    );
  }

  Map<String,dynamic>toMap(){
    return {
      'user_id' : userId,
      'post_id' : postId
    };
  }
}