class UserModel {
  final String uId;
  final String name;
  final String email;
  final String password;
  final String deviceToken;
  final String profilePic;
  final String address;
  final dynamic createdOn;
  final bool isAdmin;
  final bool isActive;
  final String phoneNumber;

  UserModel({
    required this.uId,
    required this.name,
    required this.email,
    required this.password,
    required this.deviceToken,
    required this.profilePic,
    required this.address,
    required this.createdOn,
    required this.isAdmin,
    required this.isActive,
    required this.phoneNumber,
  });

  // Converts UserModel to JSON format
  Map<String, dynamic> toJson() {
    return {
      'uId': uId,
      'name': name,
      'email': email,
      'password': password,
      'deviceToken': deviceToken,
      'profilePic': profilePic,
      'address': address,
      'createdOn': createdOn,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'phoneNumber': phoneNumber,
    };
  }

  // Creates a UserModel from JSON format
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      deviceToken: json['deviceToken'],
      profilePic: json['profilePic'],
      address: json['address'],
      createdOn: json['createdOn'],
      isAdmin: json['isAdmin'],
      isActive: json['isActive'],
      phoneNumber: json['phoneNumber'],
    );
  }
}
