import 'package:exit/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/kakaoregister_viewmodel.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입 선택'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.localregister);
              },
              child: const Text('로컬 회원가입'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final viewModel = Provider.of<KakaoRegisterViewModel>(context, listen: false);
                  await viewModel.loginWithKakao();
                  // 로그인 성공 시 추가 정보 입력 페이지로 이동
                  Navigator.pushNamed(context, RouteNames.kakaoregister);
                } catch (error) {
                  // 로그인 실패 처리
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('카카오 로그인에 실패했습니다: $error')),
                  );
                }
              },
              child: const Text('카카오 회원가입'),
            ),
          ],
        ),
      ),
    );
  }
}
