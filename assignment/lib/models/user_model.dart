class User {
  final String name;
  final String contactNumber;
  final String email;
  final String password;

  User({
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'password': password,
    };
  }
}
