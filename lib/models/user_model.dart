class UserRole {
  static const superAdmin = 'super_admin';
  static const restaurantOwner = 'restaurant_owner';
}

class UserModel {
  final String uid;
  final String email;
  final String role;
  final String? restaurantId;

  UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.restaurantId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      uid: uid,
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      restaurantId: json['restaurant_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
      'restaurant_id': restaurantId,
    };
  }
}
