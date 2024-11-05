import 'package:flutter/material.dart';

class OnboardingViewModel extends ChangeNotifier {
  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/login');
  }

  void navigateToRegister(BuildContext context) {
    Navigator.pushReplacementNamed(context, '/register');
  }
}
