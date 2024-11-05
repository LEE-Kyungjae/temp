import 'package:json_annotation/json_annotation.dart';

part 'community_post.g.dart';

@JsonSerializable()
class CommunityPost {
  final String title;
  final String content;
  final String? author;
  final String? mediaUrl;

  CommunityPost({
    required this.title,
    required this.content,
    this.author,
    this.mediaUrl,
  });

  factory CommunityPost.fromJson(Map<String, dynamic> json) => _$CommunityPostFromJson(json);
  Map<String, dynamic> toJson() => _$CommunityPostToJson(this);
}
