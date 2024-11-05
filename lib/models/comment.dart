class Comment {
  final int id;
  final String author;
  final String content;
  final DateTime createdAt;
  final int postId;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.createdAt,
    required this.postId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      postId: json['postId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'postId': postId,
    };
  }
}
