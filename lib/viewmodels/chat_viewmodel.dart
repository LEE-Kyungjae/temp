import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatService chatService;
  List<ChatMessage> messages = [];

  ChatViewModel(this.chatService);

  Future<void> sendMessage(String sender, String content) async {
    final message = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sender: sender,
      content: content,
      timestamp: DateTime.now().toIso8601String(),
    );

    await chatService.sendMessage(message);
    messages.add(message);
    notifyListeners();
  }

  Future<void> fetchMessages() async {
    messages = await chatService.fetchMessages();
    notifyListeners();
  }

  Future<void> deleteMessage(String messageId) async {
    await chatService.deleteMessage(messageId);
    messages.removeWhere((message) => message.id == messageId);
    notifyListeners();
  }

  Future<void> reportMessage(String messageId) async {
    await chatService.reportMessage(messageId);
    notifyListeners();
  }

  Future<void> sendMediaMessage(File mediaFile, String mediaType) async {
    await chatService.sendMediaMessage(mediaFile, mediaType);
    notifyListeners();
  }
}
