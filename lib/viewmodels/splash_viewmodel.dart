import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/login_viewmodel.dart';
import 'package:exit/views/main/main_navigation_view.dart';
import 'package:exit/views/onboarding_view.dart';

class SplashViewModel extends ChangeNotifier {
  Future<void> navigateToNextScreen(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    bool autoLoggedIn = await loginViewModel.autoLogin();

    if (autoLoggedIn) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainNavigationView()), // MainView로 이동
            (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingView()),
            (Route<dynamic> route) => false,
      );
    }
  }
}
