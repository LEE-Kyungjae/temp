import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/splash_viewmodel.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            viewModel.navigateToNextScreen(context);
          });
          return Scaffold(
            backgroundColor: const Color(0xFF00953B),
            body: Center(
              child: Image.asset('assets/image/reverse_logo.png', width: 200, height: 200),
            ),
          );
        },
      ),
    );
  }
}
