import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:snapverese/model/post_model.dart';


class PostDetails extends StatelessWidget {
  final PostModel post;
  final VoidCallback onDelete;
  final bool isOwnProfile;


  const PostDetails({
    super.key,
    required this.post,
    required this.onDelete,
    required this.isOwnProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: Text("Post Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
          const Gap(10),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(post.imageUrl, width: double.infinity, height: 200, fit: BoxFit.cover),
          ),
          const Gap(10),
          Text("Caption: ${post.caption}", style: TextStyle(fontSize: 16)),
          const Spacer(),
          if(isOwnProfile)
          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Confirm Delete"),
                    content: const Text("Are you sure you want to delete this post?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
                      TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete")),
                    ],
                  ),
                );
                if(context.mounted){
                if (confirm == true) {
                  onDelete();
                  Navigator.pop(context);
                }
                }
              },
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Delete",style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
