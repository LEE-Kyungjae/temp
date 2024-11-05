// lib/views/find_id_view.dart
import 'package:flutter/material.dart';

class FindIdView extends StatelessWidget {
  const FindIdView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('아이디 찾기'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                '아이디 찾기 기능을 구현하세요.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // 아이디 찾기 로직 구현
                },
                child: const Text('아이디 찾기'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}