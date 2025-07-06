import 'package:flutter/material.dart';
import 'package:snapverese/widgets/common.dart';

Widget postCard({
  required String userName,
  String? userImage,
  String? postImage,
  String? caption,
  required String timeAgo,
  required String likeCount,
  required VoidCallback likeFn,
  required bool isLiked,
}) {
  return Card(
    margin: const EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: (userImage != null && userImage.isNotEmpty)
                ? NetworkImage(userImage)
                : const AssetImage('assets/images/profile.png') as ImageProvider,
          ),
          title: Text(userName, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(timeAgo),
          trailing: const Icon(Icons.more_vert),
        ),
        if (postImage != null && postImage.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(postImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              );
            }),
          ),
        if (caption != null && caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: customText(caption, 20),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: likeFn,
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              customText(likeCount, 20),
              const SizedBox(width: 20),
              IconButton(onPressed: () {}, icon: const Icon(Icons.comment_outlined)),
            ],
          ),
        ),
        const SizedBox(height: 10),
      ],
    ),
  );
}


Widget snapItShareItLikeIt(){
  return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          "📸   Snap it. Share it. Like it.",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
    );
}