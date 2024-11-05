import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/chat_message.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import 'dart:io';

class ChatRoomView extends StatefulWidget {
  final Map<String, String> chatRoom;

  const ChatRoomView({super.key, required this.chatRoom});

  @override
  _ChatRoomViewState createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ChatViewModel>(context, listen: false).fetchMessages();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatViewModel = Provider.of<ChatViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatRoom['name']!),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatViewModel.messages.length,
              itemBuilder: (context, index) {
                final message = chatViewModel.messages[index];
                return ChatMessageTile(
                  message: message,
                  onDelete: () => chatViewModel.deleteMessage(message.id),
                  onReport: () {
                    chatViewModel.reportMessage(message.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Message reported')),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      File imageFile = File(image.path);
                      chatViewModel.sendMediaMessage(imageFile, 'image');
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.videocam),
                  onPressed: () async {
                    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
                    if (video != null) {
                      File videoFile = File(video.path);
                      chatViewModel.sendMediaMessage(videoFile, 'video');
                    }
                  },
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      chatViewModel.sendMessage(widget.chatRoom['name']!, _controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final VoidCallback onDelete;
  final VoidCallback onReport;

  const ChatMessageTile({
    super.key,
    required this.message,
    required this.onDelete,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(message.sender[0]),
      ),
      title: Text(message.sender),
      subtitle: Text(message.content),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            message.timestamp,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.delete, size: 20),
                onPressed: onDelete,
              ),
              IconButton(
                icon: const Icon(Icons.report, size: 20),
                onPressed: onReport,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
