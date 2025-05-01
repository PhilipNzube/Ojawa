class UserInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String country;
  final List<String> roles; // All roles, formatted
  final String selectedRole; // The one selected by user
  final String username;

  UserInfo({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.country,
    required this.roles,
    required this.selectedRole,
    required this.username,
  });

  factory UserInfo.fromPrefs(Map<String, String?> data) {
    return UserInfo(
      firstName: data['user_first_name'] ?? '',
      lastName: data['user_last_name'] ?? '',
      email: data['user_email'] ?? '',
      phone: data['user_phone'] ?? '',
      country: data['user_country'] ?? '',
      roles: (data['user_roles'] ?? '')
          .split(',')
          .where((e) => e.isNotEmpty)
          .toList(),
      selectedRole: data['user_selected_role'] ?? '',
      username: data['user_username'] ?? '',
    );
  }

  factory UserInfo.fromDecodedToken(
      Map<String, dynamic> token, String selectedRole) {
    final firstName = token['firstName'] ?? '';
    final lastName = token['lastName'] ?? '';
    final email = token['email'] ?? '';
    final phone = token['phone'] ?? '';
    final country = token['country']?['name'] ?? '';
    final rawRoles = List<String>.from(token['roles'] ?? []);

    final formattedRoles = rawRoles.map((role) {
      return role.replaceFirstMapped(
          RegExp(r'^[a-z]'), (m) => m.group(0)!.toUpperCase());
    }).toList();

    final formattedSelectedRole = selectedRole.replaceFirstMapped(
      RegExp(r'^[a-z]'),
      (m) => m.group(0)!.toUpperCase(),
    );

    final username = '${firstName.toLowerCase()}_${lastName.toLowerCase()}';

    return UserInfo(
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      country: country,
      roles: formattedRoles,
      selectedRole: formattedSelectedRole,
      username: username,
    );
  }

  Map<String, String> toPrefsMap() => {
        'user_first_name': firstName,
        'user_last_name': lastName,
        'user_email': email,
        'user_phone': phone,
        'user_country': country,
        'user_roles': roles.join(','), // CSV for SharedPreferences
        'user_selected_role': selectedRole,
        'user_username': username,
      };

  String get fullName => '$firstName $lastName';
}
