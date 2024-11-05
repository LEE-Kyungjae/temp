import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:exit/models/user.dart';

class UserService {
  final IOClient httpClient;
  final String baseUrl;

  UserService({required this.httpClient, required this.baseUrl});

  // Fetch user profile
  Future<User> fetchUserProfile(String userId) async {
    final response = await httpClient.get(
      Uri.parse('$baseUrl/users/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(User user) async {
    final response = await httpClient.put(
      Uri.parse('$baseUrl/users/${user.id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user profile');
    }
  }
}
