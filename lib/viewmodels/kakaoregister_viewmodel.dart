import 'dart:convert';

import 'package:exit/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class KakaoRegisterViewModel extends ChangeNotifier {
  final http.Client httpClient;
  String? _accessToken;

  KakaoRegisterViewModel({required this.httpClient}) {
    KakaoSdk.init(nativeAppKey: '4096c0067c11cc7dc5ff3d29a389d5f6'); // 앱의 네이티브 앱 키를 입력하세요.
  }

  String? get accessToken => _accessToken;

  void setAccessToken(String token) {
    _accessToken = token;
    notifyListeners();
  }

  Future<void> loginWithKakao() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      setAccessToken(token.accessToken);
    } catch (error) {
      throw Exception('카카오 로그인에 실패했습니다: $error');
    }
  }

  Future<void> registerUser(BuildContext context, String nickname, String email) async {
    if (_accessToken == null) {
      return; // Access token is required
    }

    final response = await httpClient.post(
      Uri.parse('https://your-backend-api/kakao_register'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_accessToken',
      },
      body: jsonEncode({
        'nickname': nickname,
        'email': email,
      }),
    );

    if (response.statusCode == 201) {
      // 회원가입 성공
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('회원가입 성공')),
      );
      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, RouteNames.login);
      });
    } else {
      // 회원가입 실패
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('회원가입 실패'),
            content: Text('회원가입에 실패했습니다: ${response.body}\n잠시 후 다시 시도해주세요. 지속적으로 문제가 발생하면 관리자에게 문의하세요.'),
            actions: <Widget>[
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
