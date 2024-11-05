import 'package:flutter/material.dart';
import 'package:daum_postcode_view/daum_postcode_view.dart';

class ZipCodeSearchView extends StatelessWidget {
  const ZipCodeSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('우편번호 찾기'),
      ),
      body: DaumPostcodeView(
        onComplete: (model) {
          Navigator.of(context).pop(model); // 주소 검색 완료 후 반환
        },
        options: const DaumPostcodeOptions(
          animation: true,
          hideEngBtn: true,
          themeType: DaumPostcodeThemeType.darknessTheme,
        ),
      ),
    );
  }
}
