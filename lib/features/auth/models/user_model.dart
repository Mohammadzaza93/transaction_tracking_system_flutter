class UserModel {
  final int id;
  final String fullName;
  final String role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      fullName: json['full_name'],
      role: json['role'],
    );
  }
}
