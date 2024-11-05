import 'dart:convert';
import 'package:exit/models/post.dart';
import 'package:http/http.dart' as http;

class PostService {
  final String baseUrl;
  final http.Client httpClient;

  PostService(this.baseUrl, this.httpClient);

  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((post) => Post.fromJson(post)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> addPost(Post post) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add post');
    }
  }

  Future<void> updatePost(Post post) async {
    final response = await http.put(
      Uri.parse('$baseUrl/${post.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(post.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update post');
    }
  }

  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
