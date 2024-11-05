import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:convert';

class LocalRegisterViewModel extends ChangeNotifier {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController addressDetailController = TextEditingController();
  final TextEditingController zipCodeController = TextEditingController(); // 우편번호 필드 추가

  final IOClient httpClient;

  bool _isEmailChecked = false;
  bool get isEmailChecked => _isEmailChecked;

  String? _gender;
  String? get gender => _gender;

  bool _passwordsMatch = true;
  bool get passwordsMatch => _passwordsMatch;

  int currentStep = 0;
  final PageController pageController = PageController();

  LocalRegisterViewModel({required this.httpClient}) {
    emailController.addListener(_onEmailChanged);
  }

  void _onEmailChanged() {
    if (_isEmailChecked) {
      _isEmailChecked = false;
      notifyListeners();
    }
  }

  void resetEmailCheck() {
    _isEmailChecked = false;
    notifyListeners();
  }

  void setGender(String? newGender) {
    _gender = newGender;
    notifyListeners();
  }

  void checkPasswordsMatch() {
    _passwordsMatch = passwordController.text == confirmPasswordController.text;
    notifyListeners();
  }

  Future<void> checkEmail(BuildContext context) async {
    final response = await httpClient.get(
      Uri.parse('https://10.0.2.2:8443/auth/check_email?email=${emailController.text}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      bool isAvailable = data['available'];
      if (isAvailable) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사용 가능한 이메일입니다.')),
        );
        _isEmailChecked = true;
        notifyListeners();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('이미 사용 중인 이메일입니다.')),
        );
        _isEmailChecked = false;
        notifyListeners();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이메일 확인 실패: ${response.body}')),
      );
    }
  }

  Future<void> register(BuildContext context) async {
    if (!_isEmailChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('이메일 중복 확인을 해주세요.')),
      );
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('비밀번호와 비밀번호 확인이 일치하지 않습니다.')),
      );
      return;
    }

    final response = await httpClient.post(
      Uri.parse('https://10.0.2.2:8443/auth/register'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': emailController.text,
        'password': passwordController.text,
        'address': '${zipCodeController.text} ${addressController.text}',
        'addressDetail': addressDetailController.text,
        'gender': _gender ?? 'OTHER',
        'zipCode': zipCodeController.text,
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const AlertDialog(
            title: Text('회원가입 성공'),
            content: Text('회원가입이 성공적으로 완료되었습니다.'),
          );
        },
      );

      Future.delayed(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
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

  void nextStep() {
    if (currentStep < 2) {
      currentStep++;
      pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      currentStep--;
      pageController.animateToPage(
        currentStep,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      notifyListeners();
    }
  }
}
