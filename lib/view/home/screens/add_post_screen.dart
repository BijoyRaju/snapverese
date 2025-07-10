import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/post_controller.dart';
import 'package:snapverese/widgets/common.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {

  final TextEditingController controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.close)),
      ),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 10, left: 10),
          child: ListView(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Center(child: customText("Create New Post", 26,fontWeight: FontWeight.bold)),
                  const Gap(20),
                  if(_selectedImage != null)
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(12),
                      child: Image.file(
                        _selectedImage!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      ),
                      if(_selectedImage != null) const Gap(10),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x66888888),
                          spreadRadius: 2,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: TextField(
                      controller: controller,
                      maxLines: 10,
                      decoration: InputDecoration(
                        hintText: "What's on your mind?",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Gap(1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: showImagePickerOptions
                        ,
                        icon: Icon(Icons.photo_size_select_actual_rounded),
                        iconSize: 30,
                      ),
                    ],
                  ),
                  Gap(20),
                  customButton("Save", handleSavePost, null)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  
  Future <void> pickImage(ImageSource source)async{
    final pickedFile = await _picker.pickImage(source: source);
    if(pickedFile != null){
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

 void showImagePickerOptions(){
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text("Camera"),
            onTap: (){
              Navigator.pop(context);
              pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text("Gallery"),
            onTap: (){
              Navigator.pop(context);
              pickImage(ImageSource.gallery);
            },
          )
        ],
      )
    );
  }


  Future<void> handleSavePost() async {
  final caption = controller.text.trim();
  if (_selectedImage == null || caption.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select an image and enter a caption')),
    );
    return;
  }
  final postController = Provider.of<PostController>(context, listen: false);
  try {   
    await postController.createPost(
      imageFile: _selectedImage!,
      caption: caption,
    );
    controller.clear();
    if(mounted){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Post created successfully')));
      Navigator.pop(context);
    }
  } catch (e) {
    if(mounted){
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to post: $e')));}
  } 
}
  
}