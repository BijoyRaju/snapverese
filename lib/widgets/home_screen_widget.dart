import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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
          leading: userImage != null && userImage.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userImage),
                )
              : const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
          title: Text(
            userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(timeAgo),
          trailing: const Icon(Icons.more_vert),
        ),

        // Post Image with shimmer
        if (postImage != null && postImage.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: postImage,
              placeholder: (context, url) => Shimmer.fromColors(
                baseColor: Colors.grey.shade300,
                highlightColor: Colors.grey.shade100,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ),
              errorWidget: (context, url, error) => Container(
                height: 200,
                color: Colors.grey[300],
                child: const Center(child: Icon(Icons.broken_image)),
              ),
              fit: BoxFit.cover,
            ),
          ),

        // Caption
        if (caption != null && caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Text(caption, style: const TextStyle(fontSize: 20)),
          ),

        // Like & Comment row
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
              Text(likeCount, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 20),
              IconButton(
                onPressed: () {
                  // TODO: Add comment screen
                },
                icon: const Icon(Icons.comment_outlined),
              ),
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