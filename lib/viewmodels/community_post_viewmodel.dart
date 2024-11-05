import 'package:flutter/material.dart';
import '../models/community_post.dart';
import '../services/community_post_service.dart';
import 'dart:io';

class CommunityPostViewModel extends ChangeNotifier {
  final CommunityPostService _service;
  bool _isLoading = false;

  CommunityPostViewModel(this._service);

  bool get isLoading => _isLoading;

  Future<void> createPost(String title, String content, {File? media}) async {
    _isLoading = true;
    notifyListeners();

    try {
      print('Creating post with title: $title, content: $content');
      final newPost = CommunityPost(title: title, content: content);
      await _service.createPost(newPost, media: media);
      print('Post created successfully');
    } catch (e) {
      print('Error creating post: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<CommunityPost>> fetchPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _service.fetchPosts();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.deletePost(postId);
      print('Post deleted successfully');
    } catch (e) {
      print('Error deleting post: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
