import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';
import 'dart:io';

class ChatService {
  final String baseUrl;
  final http.Client httpClient;

  ChatService(this.baseUrl, this.httpClient);

  // 메시지 보내기
  Future<void> sendMessage(ChatMessage message) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/sendMessage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(message.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send message');
    }
  }

  // 메시지 받기
  Future<List<ChatMessage>> fetchMessages() async {
    final response = await httpClient.get(Uri.parse('$baseUrl/getMessages'));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => ChatMessage.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  // 메시지 삭제
  Future<void> deleteMessage(String messageId) async {
    final response = await httpClient.delete(
      Uri.parse('$baseUrl/chat/delete/$messageId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete message');
    }
  }

  // 메시지 신고
  Future<void> reportMessage(String messageId) async {
    final response = await httpClient.post(
      Uri.parse('$baseUrl/chat/report/$messageId'),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to report message');
    }
  }

  // 미디어 메시지 전송
  Future<void> sendMediaMessage(File mediaFile, String mediaType) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/chat/send_media'));
    request.files.add(await http.MultipartFile.fromPath('media', mediaFile.path));
    request.fields['media_type'] = mediaType;

    var response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to send media message');
    }
  }
}
