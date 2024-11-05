import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CommunityPostCreateView extends StatefulWidget {
  @override
  _CommunityPostCreateViewState createState() => _CommunityPostCreateViewState();
}

class _CommunityPostCreateViewState extends State<CommunityPostCreateView> {
  final TextEditingController _textController = TextEditingController();
  File? _imageFile;
  File? _videoFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickVideo() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
    }
  }

  void _submitPost() {
    final text = _textController.text;
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('글을 작성해주세요')),
      );
      return;
    }
    // 파일 및 텍스트 업로드 처리 로직
    print('텍스트: $text');
    if (_imageFile != null) print('이미지 파일 경로: ${_imageFile!.path}');
    if (_videoFile != null) print('동영상 파일 경로: ${_videoFile!.path}');

    // 업로드 후 초기화
    setState(() {
      _textController.clear();
      _imageFile = null;
      _videoFile = null;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티 글쓰기'),
        actions: [
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _submitPost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: '여기에 글을 작성하세요',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            if (_imageFile != null)
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Image.file(_imageFile!),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _imageFile = null;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            if (_videoFile != null)
              Column(
                children: [
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        height: 200,
                        color: Colors.black,
                        child: Center(
                          child: Text(
                            '동영상 파일: ${_videoFile!.path.split('/').last}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.cancel, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _videoFile = null;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            const SizedBox(height: 10),
            /*Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.photo),
                  label: Text('이미지 선택'),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _pickVideo,
                  icon: Icon(Icons.videocam),
                  label: Text('동영상 선택'),
                ),
              ],
            ),*/
          ],
        ),
      ),
    );
  }
}
