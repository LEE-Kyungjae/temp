import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/community_post.dart';
import 'dart:io';

class CommunityPostService {
  final String baseUrl;
  final http.Client httpClient;

  CommunityPostService(this.baseUrl, this.httpClient);

  Future<CommunityPost> createPost(CommunityPost post, {File? media}) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/api/community'));
    request.fields['title'] = post.title;
    request.fields['content'] = post.content;
    if (post.author != null) {
      request.fields['author'] = post.author!;
    }

    if (media != null) {
      final mimeType = media.path.split('.').last;
      print('Uploading file: ${media.path}, MIME type: $mimeType');
      request.files.add(
        await http.MultipartFile.fromPath(
          'media',
          media.path,
          contentType: MediaType('image', mimeType),
        ),
      );
    }

    print('Sending request with fields: ${request.fields}');
    final response = await request.send();
    if (response.statusCode == 201) {
      final responseBody = await response.stream.bytesToString();
      print('Response body: $responseBody');
      return CommunityPost.fromJson(jsonDecode(responseBody));
    } else {
      final responseBody = await response.stream.bytesToString();
      print('Failed to create post: ${response.statusCode}, $responseBody');
      throw Exception('Failed to create post');
    }
  }

  Future<List<CommunityPost>> fetchPosts() async {
    final response = await httpClient.get(Uri.parse('$baseUrl/api/community'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => CommunityPost.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<void> deletePost(String postId) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/api/community/$postId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete post');
    }
  }
}
