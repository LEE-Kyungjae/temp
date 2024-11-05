import 'package:exit/models/comment.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final String mediaUrl;
  final DateTime createdAt;
  final int likeCount;
  final List<Comment> comments;
  final List<String> tags;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.mediaUrl,
    required this.createdAt,
    required this.likeCount,
    required this.comments,
    required this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: json['author'],
      mediaUrl: json['mediaUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      likeCount: json['likeCount'],
      comments: (json['comments'] as List).map((i) => Comment.fromJson(i)).toList(),
      tags: List<String>.from(json['tags']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author,
      'mediaUrl': mediaUrl,
      'createdAt': createdAt.toIso8601String(),
      'likeCount': likeCount,
      'comments': comments.map((e) => e.toJson()).toList(),
      'tags': tags,
    };
  }
}
