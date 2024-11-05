import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/onboarding_viewmodel.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF2F2F2F),
        padding: const EdgeInsets.all(16.0),
        child: const Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnboardingLogo(),
                SizedBox(height: 20),
                OnboardingText(),
                SizedBox(height: 40),
                StartButton(),
                SizedBox(height: 20),
                LoginPrompt(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingLogo extends StatelessWidget {
  const OnboardingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/image/reverse_logo.png',
      width: 200,
      height: 200,
    );
  }
}

class OnboardingText extends StatelessWidget {
  const OnboardingText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '일상에서 느낄 수 없는 짜릿함\n내 지역에서 탈출을 시작해 보세요',
      style: TextStyle(color: Colors.white, fontSize: 18),
      textAlign: TextAlign.center,
    );
  }
}

class StartButton extends StatelessWidget {
  const StartButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Provider.of<OnboardingViewModel>(context, listen: false).navigateToRegister(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF00953B),
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Text('시작하기', style: TextStyle(fontSize: 18, color: Colors.white)),
    );
  }
}

class LoginPrompt extends StatelessWidget {
  const LoginPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Provider.of<OnboardingViewModel>(context, listen: false).navigateToLogin(context);
      },
      child: RichText(
        text: const TextSpan(
          text: '이미 등록된 이용자이신가요? ',
          style: TextStyle(color: Colors.white),
          children: <TextSpan>[
            TextSpan(
              text: '로그인',
              style: TextStyle(color: Color(0xFF00953B)),
            ),
          ],
        ),
      ),
    );
  }
}
