import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/login_viewmodel.dart';
import 'package:flutter/gestures.dart';
import '../onboarding_view.dart';

class LoginView extends StatelessWidget {
  final http.Client httpClient;
  const LoginView({super.key, required this.httpClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginViewModel(httpClient: httpClient),
      child: Consumer<LoginViewModel>(
        builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingView()),
                    (Route<dynamic> route) => false,
              );
              return false;
            },
            child: FutureBuilder<bool>(
              future: viewModel.autoLogin(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data == true) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/main');
                  });
                  return Container(); // Avoid build error due to calling Navigator in FutureBuilder
                } else {
                  return Scaffold(
                    body: LoginForm(viewModel: viewModel),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  final LoginViewModel viewModel;
  const LoginForm({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF636363), // 배경색 설정
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView( // 스크롤 가능하도록 설정
        child: Center(
          child: Form(
            key: viewModel.formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/image/reverse_logo.png', // 로고 이미지 사용
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: 330,
                  child: TextFormField(
                    controller: viewModel.emailController,
                    decoration: InputDecoration(
                      labelText: '이메일',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '이메일을 입력하세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 330,
                  child: TextFormField(
                    controller: viewModel.passwordController,
                    decoration: InputDecoration(
                      labelText: '비밀번호',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '비밀번호를 입력하세요';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => viewModel.login(context),
                  child: Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00953B), // 탈출 시작 버튼 색상
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '탈출 시작',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => viewModel.loginWithKakao(context),
                  child: Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 4),
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0), // 이미지 모서리 둥글게 설정
                      child: Image.asset(
                        'assets/image/kakao_login_large_wide.png',
                        width: 330, // 적절한 너비 설정
                        height: 50, // 적절한 높이 설정
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => viewModel.navigateToRegister(context),
                  child: RichText(
                    text: TextSpan(
                      text: '처음 오신 분이라면 ',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: '회원가입',
                          style: TextStyle(color: Colors.green[300]),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => viewModel.navigateToFindId(context),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      children: <TextSpan>[
                        TextSpan(
                          text: '아이디 찾기',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        const TextSpan(
                          text: ' | ', // 사이에 구분 기호 추가
                        ),
                        TextSpan(
                          text: '비밀번호 찾기',
                          style: TextStyle(color: Colors.grey[400]),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              viewModel.navigateToFindPassword(context);
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
