import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyProfileView extends StatefulWidget {
  const MyProfileView({super.key});

  @override
  _MyProfileViewState createState() => _MyProfileViewState();
}

class _MyProfileViewState extends State<MyProfileView> {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // 예시: JWT 토큰에서 사용자 정보를 로드하는 로직
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      // 사용자 정보를 로드하여 _name _email에 설정하는 로직 추가
      setState(() {
        _name = '홍길동'; // 예시 이름
        _email = 'hong@example.com'; // 예시 이메일
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // 사용자 정보를 저장하는 로직 추가
      print('Name: $_name, Email: $_email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내 정보 관리'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: '이름'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이름을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: '이메일'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력하세요';
                  }
                  return null;
                },
                onSaved: (value) {
                  _email = value ?? '';
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUserData,
                child: const Text('저장'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
