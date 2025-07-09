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

  // Add this method 👇
  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    String? bio,
    String? profileImage,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      profileImage: profileImage ?? this.profileImage,
    );
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

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'bio': bio,
      'profile_image': profileImage,
    };
  }
}
