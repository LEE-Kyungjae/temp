import 'package:exit/views/main/personal/my_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../terms_and_conditions_view.dart';
import 'package:exit/viewmodels/theme_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonalView extends StatelessWidget {
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  const PersonalView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.separated(
        itemCount: 12,
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey.shade300,
            thickness: 1,
            indent: 16,
            endIndent: 16,
          );
        },
        itemBuilder: (context, index) {
          return _buildListTile(context, index);
        },
      ),
    );
  }

  Widget _buildListTile(BuildContext context, int index) {
    if (index == 10) {
      return SwitchListTile(
        title: const Text('다크모드'),
        value: Provider.of<ThemeViewModel>(context).isDarkMode,
        onChanged: (value) {
          Provider.of<ThemeViewModel>(context, listen: false).toggleTheme();
        },
      );
    } else if (index == 11) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ElevatedButton(
          onPressed: () {
            _showLogoutConfirmationDialog(context);
          },
          child: const Text('로그아웃'),
        ),
      );
    } else {
      return GestureDetector(
        onTap: () => _handleTileTap(context, index),
        child: Container(
          height: 40,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            _getTitle(index),
            style: const TextStyle(height: 1),
          ),
        ),
      );
    }
  }

  void _handleTileTap(BuildContext context, int index) {
    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MyProfileView()),
      );
    } else if (index == 6) {
      _showTermsAndConditions(context);
    } else if (index == 7) {
      _showKakaoTalkDialog(context);
    }
    // 여기에 다른 인덱스의 경우 필요한 동작을 추가할 수 있습니다.
  }

  String _getTitle(int index) {
    switch (index) {
      case 0:
        return '내 정보 관리';
      case 1:
        return '결제 및 이용내역';
      case 2:
        return '알림설정';
      case 3:
        return '관심 정보 설정';
      case 4:
        return '포인트 관리';
      case 5:
        return '개발자 공지사항';
      case 6:
        return '약관 및 정책';
      case 7:
        return '고객센터';
      case 8:
        return '버전정보 1.0.0';
      case 9:
        return '오픈소스 라이선스';
      default:
        return '';
    }
  }

  void _showTermsAndConditions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (BuildContext context, ScrollController scrollController) {
            return TermsAndConditionsView(scrollController: scrollController);
          },
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('로그아웃'),
          content: const Text('정말 로그아웃 하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('로그아웃'),
              onPressed: () async {
                await secureStorage.delete(key: 'jwt_token');
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _showKakaoTalkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('고객센터'),
          content: const Text('카카오톡 상담톡으로 연결하시겠습니까?'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('연결'),
              onPressed: () async {
                const url = 'https://pf.kakao.com/_YOUR_KAKAO_CHANNEL_URL';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
