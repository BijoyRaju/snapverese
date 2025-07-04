import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snapverese/widgets/common.dart';

Widget postCard(
  String userName,
  String? userImage,
  String? postImage,
  String? caption,
  String timeAgo,
) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        // Post Header
        ListTile(
          leading: CircleAvatar(
            backgroundImage: (userImage != null && userImage.isNotEmpty)
                ? NetworkImage(userImage)
                : AssetImage('assets/images/profile.png') as ImageProvider,
          ),
          title: Text(
            userName.isNotEmpty ? userName : 'Unknown User',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(timeAgo),
          trailing: Icon(Icons.more_vert),
        ),

        // Post Image
        if (postImage != null && postImage.isNotEmpty)
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(postImage, fit: BoxFit.cover, errorBuilder: (_, __, ___) {
              return Container(
                height: 200,
                color: Colors.grey[300],
                child: Center(child: Icon(Icons.broken_image)),
              );
            }),
          ),

        // Caption
        if (caption != null && caption.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: customText(caption, 20),
          ),

        // Like & Comment Buttons
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Icon(Icons.favorite_border,size: 30,),
              Gap(20),
              Icon(Icons.comment_outlined,size: 30,),
            ],
          ),
        ),
        Gap(10),
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