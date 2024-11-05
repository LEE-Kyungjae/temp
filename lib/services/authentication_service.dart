import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:exit/models/user.dart';

class AuthenticationService {
  final IOClient httpClient;
  final String baseUrl;

  AuthenticationService({required this.httpClient, required this.baseUrl});

  // Register user
  Future<void> registerUser(User user) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to register user');
    }
  }

  // Login user
  Future<User> loginUser(String email, String password) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to login user');
    }
  }

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
