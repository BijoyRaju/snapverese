class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String comment;
  final DateTime createdAt;
  
  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.comment,
    required this.createdAt
  });

  Map<String,dynamic> toMap(){
    return {
      'id' : id,
      'post_id' : postId,
      'user_id' : userId,
      'comment' : comment,
      'created_at' : createdAt
    };
  }

  factory CommentModel.fromMap(Map<String,dynamic>map){
    return CommentModel(
      id: map['id'],
      postId: map['postId'],
      userId: map['userId'],
      comment: map['comment'],
      createdAt: map['createdAt']
    );
  }
}