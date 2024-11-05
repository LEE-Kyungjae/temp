import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exit/viewmodels/localregister_viewmodel.dart';
import 'package:exit/views/register/zip_code_search_view.dart';
import 'package:http/io_client.dart';

class LocalRegisterView extends StatelessWidget {
  final IOClient httpClient;

  const LocalRegisterView({super.key, required this.httpClient});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LocalRegisterViewModel(httpClient: httpClient),
      child: Consumer<LocalRegisterViewModel>(
        builder: (context, viewModel, child) {
          return WillPopScope(
            onWillPop: () async {
              if (viewModel.currentStep > 0) {
                viewModel.previousStep();
                return false;
              } else {
                Navigator.pop(context); // 이전 화면으로 돌아감
                return true;
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('회원가입'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    if (viewModel.currentStep > 0) {
                      viewModel.previousStep();
                    } else {
                      Navigator.pop(context); // 이전 화면으로 돌아감
                    }
                  },
                ),
              ),
              body: Column(
                children: [
                  StepProgressIndicator(
                    totalSteps: 3,
                    currentStep: viewModel.currentStep + 1,
                  ),
                  Expanded(
                    child: PageView(
                      controller: viewModel.pageController,
                      onPageChanged: (index) {
                        viewModel.currentStep = index;
                      },
                      physics: const NeverScrollableScrollPhysics(),
                      children: const [
                        Step1(),
                        Step2(),
                        Step3(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class StepProgressIndicator extends StatelessWidget {
  final int totalSteps;
  final int currentStep;

  const StepProgressIndicator({super.key, required this.totalSteps, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(totalSteps, (index) {
          return Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 10,
              decoration: BoxDecoration(
                color: index < currentStep ? Colors.green : Colors.grey,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class Step1 extends StatelessWidget {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const EmailField(),
            const PasswordField(),
            const ConfirmPasswordField(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: viewModel.isEmailChecked
                      ? () => viewModel.nextStep()
                      : null,
                  child: const Text('다음'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Step2 extends StatelessWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ZipCodeField(),
            const AddressField(),
            const AddressDetailField(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => viewModel.previousStep(),
                  child: const Text('이전'),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.nextStep(),
                  child: const Text('다음'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Step3 extends StatelessWidget {
  const Step3({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GenderField(),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => viewModel.previousStep(),
                  child: const Text('이전'),
                ),
                ElevatedButton(
                  onPressed: () => viewModel.register(context),
                  child: const Text('회원가입'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EmailField extends StatelessWidget {
  const EmailField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return TextField(
      controller: viewModel.emailController,
      decoration: InputDecoration(
        labelText: '이메일',
        suffixIcon: IconButton(
          icon: const Icon(Icons.check),
          onPressed: () => viewModel.checkEmail(context),
        ),
      ),
    );
  }
}

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return TextField(
      controller: viewModel.passwordController,
      decoration: const InputDecoration(labelText: '비밀번호'),
      obscureText: true,
      onChanged: (text) => viewModel.checkPasswordsMatch(),
    );
  }
}

class ConfirmPasswordField extends StatelessWidget {
  const ConfirmPasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return TextField(
      controller: viewModel.confirmPasswordController,
      decoration: InputDecoration(
        labelText: '비밀번호 확인',
        errorText: viewModel.passwordsMatch ? null : '비밀번호가 일치하지 않습니다.',
      ),
      obscureText: true,
      onChanged: (text) => viewModel.checkPasswordsMatch(),
    );
  }
}

class ZipCodeField extends StatelessWidget {
  const ZipCodeField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: viewModel.zipCodeController,
            decoration: const InputDecoration(labelText: '우편번호'),
            readOnly: true,
            onTap: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ZipCodeSearchView(),
                ),
              );
              if (result != null) {
                viewModel.zipCodeController.text = result.zonecode;
                viewModel.addressController.text = result.address;
              }
            },
          ),
        ),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ZipCodeSearchView(),
              ),
            );
            if (result != null) {
              viewModel.zipCodeController.text = result.zonecode;
              viewModel.addressController.text = result.address;
            }
          },
          child: const Text('우편번호 찾기'),
        ),
      ],
    );
  }
}

class AddressField extends StatelessWidget {
  const AddressField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return TextField(
      controller: viewModel.addressController,
      decoration: const InputDecoration(
        labelText: '주소',
        hintText: '우편번호로 자동 입력',
      ),
      readOnly: true,
    );
  }
}

class AddressDetailField extends StatelessWidget {
  const AddressDetailField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return TextField(
      controller: viewModel.addressDetailController,
      decoration: const InputDecoration(labelText: '상세주소'),
    );
  }
}

class GenderField extends StatelessWidget {
  const GenderField({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LocalRegisterViewModel>(context);
    return Column(
      children: [
        const Text('성별'),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: ['남성', '여성', '기타'].map((String koreanLabel) {
            String englishValue = '';
            if (koreanLabel == '남성') {
              englishValue = 'MALE';
            } else if (koreanLabel == '여성') {
              englishValue = 'FEMALE';
            } else if (koreanLabel == '기타') {
              englishValue = 'OTHER';
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: ChoiceChip(
                label: Text(koreanLabel),
                selected: viewModel.gender == englishValue,
                onSelected: (bool selected) {
                  viewModel.setGender(selected ? englishValue : null);
                },
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
