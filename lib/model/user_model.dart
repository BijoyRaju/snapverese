class UserModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String? bio;
  final String? profileImage;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    this.bio,
    this.profileImage,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'bio' : bio,
      'profile_image': profileImage,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      bio: map['bio'],
      profileImage: map['profile_image'],
    );
  }
}
