// lib/models/chat_message.dart
class ChatMessage {
  final String id;
  final String sender;
  final String content;
  final String timestamp;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.content,
    required this.timestamp,
  });

  // JSON 직렬화
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': sender,
      'content': content,
      'timestamp': timestamp,
    };
  }

  // JSON 역직렬화
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'],
      sender: json['sender'],
      content: json['content'],
      timestamp: json['timestamp'],
    );
  }
}
