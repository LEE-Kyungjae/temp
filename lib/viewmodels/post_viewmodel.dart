import 'package:exit/models/post.dart';
import 'package:exit/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PostViewModel extends ChangeNotifier {
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  final PostService _postService;

  PostViewModel(String baseUrl, http.Client httpClient)
      : _postService = PostService(baseUrl, httpClient);

  Future<void> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    _posts = await _postService.getPosts();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    await _postService.addPost(post);
    await fetchPosts();
  }

  Future<void> updatePost(Post post) async {
    await _postService.updatePost(post);
    await fetchPosts();
  }

  Future<void> deletePost(int id) async {
    await _postService.deletePost(id);
    await fetchPosts();
  }
}
