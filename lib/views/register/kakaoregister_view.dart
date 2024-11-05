import 'package:exit/viewmodels/kakaoregister_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KakaoRegisterView extends StatelessWidget {
  const KakaoRegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nicknameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('추가 정보 입력')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nicknameController,
              decoration: const InputDecoration(labelText: '닉네임'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final viewModel = Provider.of<KakaoRegisterViewModel>(context, listen: false);
                viewModel.registerUser(
                  context,
                  nicknameController.text,
                  emailController.text,
                );
              },
              child: const Text('회원가입 완료'),
            ),
          ],
        ),
      ),
    );
  }
}
