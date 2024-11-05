// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityPost _$CommunityPostFromJson(Map<String, dynamic> json) =>
    CommunityPost(
      title: json['title'] as String,
      content: json['content'] as String,
      author: json['author'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
    );

Map<String, dynamic> _$CommunityPostToJson(CommunityPost instance) =>
    <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'author': instance.author,
      'mediaUrl': instance.mediaUrl,
    };
