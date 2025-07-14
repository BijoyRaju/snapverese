import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:snapverese/controller/user_controller.dart';
import 'package:snapverese/model/user_model.dart';
import 'package:snapverese/widgets/common.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  File? pickedImageFile;


  String? uploadedImageUrl;

  @override
  void initState() {
    final userController = Provider.of<UserController>(context,listen: false);
    userController.fetchCurrentUser().then((_){
      final user = userController.currentUser;
      if(user != null){
        nameController.text = user.name;
        emailController.text = user.email;
        phoneController.text = user.phone;
        bioController.text = user.bio ?? "";
        uploadedImageUrl = user.profileImage;
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
          child: AppBar(
            backgroundColor: Colors.black,
            title: customText("Edit Profile", 24, fontWeight: FontWeight.w500, color: Colors.white),
            foregroundColor: Colors.white,
            centerTitle: true,
            elevation: 4,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundImage: pickedImageFile != null
                        ? FileImage(pickedImageFile!)
                        : uploadedImageUrl != null && uploadedImageUrl!.isNotEmpty
                            ? NetworkImage(uploadedImageUrl!)
                            : const AssetImage('assets/images/profile.png') as ImageProvider,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 18,
                      child: IconButton(
                        onPressed: (){
                          showModalBottomSheet(
                            context: context,
                            builder: (context){
                              return SafeArea(child: Wrap(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.camera_alt),
                                    title: Text("Take a photo"),
                        
                                    onTap: ()async{
                                      Navigator.pop(context);
                                      await _pickAndUploadImage(ImageSource.camera);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: Text("Choose from gallery"),
                                    onTap: ()async{
                                      Navigator.pop(context);
                                      await _pickAndUploadImage(ImageSource.gallery);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.delete),
                                    title: Text("Delete"),
                                    onTap: ()async{
                                      Navigator.pop(context);
                                      await Provider.of<UserController>(context,listen: false).deleteProfilePhoto();
                                        setState(() {
                                          uploadedImageUrl = '';
                                          pickedImageFile = null;
                                        });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile photo deleted")));
                                    },

                                  )
                                ],
                              ));
                            });
                        },
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(30),
            customText("Name", 16, fontWeight: FontWeight.w500),
            const Gap(8),
            customTextField("", nameController),
            const Gap(20),
            customText("Email", 16, fontWeight: FontWeight.w500),
            const Gap(8),
            customTextField("", emailController),
            const Gap(20),
            customText("Phone", 16, fontWeight: FontWeight.w500),
            const Gap(8),
            customTextField("", phoneController),
            const Gap(20),
            customText("Bio", 16, fontWeight: FontWeight.w500),
            const Gap(8),
            customTextField("", bioController),
            const Gap(30),
            customButton("Save", ()async{
              final userController = await Provider.of<UserController>(context,listen: false);
              final oldUser = userController.currentUser;

              if(oldUser == null)return;

                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final phone = phoneController.text.trim();

                if(context.mounted){
                if(name.isEmpty || email.isEmpty || phone.isEmpty){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields"))
                  );
                  return;
                }

                if(!isValidEmail(email)){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter a valid gmail"))
                  );
                  return;
                }

                // if(!isValidPhone(phone)){
                //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter a valid phone number"))
                //   );
                //   return;
                // }
                }

              final updateUser = UserModel(
                uid: oldUser.uid,
                name: nameController.text,
                email: emailController.text,
                phone: phoneController.text,
                bio: bioController.text,
                profileImage: uploadedImageUrl
              );
              await userController.updateUserProfile(updateUser);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile Updated")));
            }, null),
          ],
        ),
      ),
    );
  }

Future<void> _pickAndUploadImage(ImageSource source) async {
  final picker = ImagePicker();
  final image = await picker.pickImage(source: source);
  if (image != null) {
    final file = File(image.path);

    setState(() {
      pickedImageFile = file; 
    });

    final url = await Provider.of<UserController>(context, listen: false)
        .uploadProfileImage(file);

    if (url != null) {
      setState(() {
        uploadedImageUrl = "$url?${DateTime.now().millisecondsSinceEpoch}";
      });
    }
  }
}

 bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[6-9]\d{9}$'); 
    return phoneRegex.hasMatch(phone);
  }

}
