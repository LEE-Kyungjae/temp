import 'package:exit/models/post.dart';
import 'package:exit/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostProvider with ChangeNotifier {
  List<Post> _posts = [];
  List<Post> _filteredPosts = [];
  bool _isLoading = false;

  List<Post> get posts => _filteredPosts;
  bool get isLoading => _isLoading;

  final PostService _postService;

  PostProvider(String baseUrl, http.Client httpClient)
      : _postService = PostService(baseUrl, httpClient) {
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    _posts = await _postService.getPosts();
    _filteredPosts = _posts;

    _isLoading = false;
    notifyListeners();
  }

  void searchPosts(String query) {
    if (query.isEmpty) {
      _filteredPosts = _posts;
    } else {
      _filteredPosts = _posts.where((post) {
        return post.title.toLowerCase().contains(query.toLowerCase()) ||
            post.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}
