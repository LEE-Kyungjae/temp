import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginViewModel extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final http.Client httpClient;

  LoginViewModel({required this.httpClient});

  Future<bool> autoLogin() async {
    String? token = await secureStorage.read(key: 'jwt_token');
    if (token != null) {
      final response = await httpClient.get(
        Uri.parse('https://10.0.2.2:8443/auth/verifyToken'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return true; // 로그인 성공
      } else {
        await secureStorage.delete(key: 'jwt_token');
        return false; // 로그인 실패
      }
    }
    return false; // 토큰 없음
  }

  Future<void> login(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      final response = await httpClient.post(
        Uri.parse('https://10.0.2.2:8443/auth/login'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': emailController.text,
          'password': passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final token = response.body;
        await secureStorage.write(key: 'jwt_token', value: token);
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('로그인 실패: ${response.body}')),
        );
      }
    }
  }

  Future<void> loginWithKakao(BuildContext context) async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
      String authorizationCode = token.accessToken;

      final response = await httpClient.post(
        Uri.parse('https://10.0.2.2:8443/auth/oauth'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'authorizationCode': authorizationCode,
        }),
      );

      if (response.statusCode == 200) {
        final jwtToken = response.body;
        await secureStorage.write(key: 'jwt_token', value: jwtToken);
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카카오 로그인 실패: ${response.body}')),
        );
      }
    } catch (error) {
      print('로그인 실패: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('카카오 로그인 실패: $error')),
      );
    }
  }

  void navigateToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  void navigateToFindId(BuildContext context) {
    Navigator.pushNamed(context, '/find_id');
  }

  void navigateToFindPassword(BuildContext context) {
    Navigator.pushNamed(context, '/find_password');
  }
}
