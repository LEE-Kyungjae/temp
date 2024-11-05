import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import '../../../viewmodels/chat_viewmodel.dart';
import '../../../services/chat_service.dart';
import '../../../services/http_client_service.dart';
import 'chat_room_view.dart';
import './community_post_create_view.dart';

class CommunityView extends StatefulWidget {
  const CommunityView({super.key});

  @override
  _CommunityViewState createState() => _CommunityViewState();
}

class _CommunityViewState extends State<CommunityView> with SingleTickerProviderStateMixin {
  BannerAd? _bannerAd;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('Ad failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) {
          print('Ad opened.');
        },
        onAdClosed: (Ad ad) {
          print('Ad closed.');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('커뮤니티 | 대화'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '커뮤니티'),
            Tab(text: '대화'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCommunityTab(),
          _buildChatTab(context),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildCommunityTab() {
    return const Center(
      child: Text('커뮤니티 내용'),
    );
  }

  Widget _buildChatTab(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: chatRooms.length,
                itemBuilder: (context, index) {
                  final chatRoom = chatRooms[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chatRoom['avatarUrl']!),
                    ),
                    title: Text(chatRoom['name']!),
                    subtitle: Text(chatRoom['lastMessage']!),
                    trailing: Text(chatRoom['time']!),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) => ChangeNotifierProvider(
                            create: (_) => ChatViewModel(ChatService('https://10.0.2.2:8443', createIoClient())),
                            child: ChatRoomView(chatRoom: chatRoom),
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            const begin = Offset(1.0, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.easeInOut;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (_bannerAd != null)
              SizedBox(
                height: _bannerAd!.size.height.toDouble(),
                width: _bannerAd!.size.width.toDouble(),
                child: AdWidget(ad: _bannerAd!),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (_tabController.index == 0) {
          // 커뮤니티 글쓰기 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityPostCreateView(),
            ),
          );
        } else if (_tabController.index == 1) {
          // 대화 글쓰기 화면으로 이동
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPostCreateView(),
            ),
          );
        }
      },
      child: const Icon(Icons.edit),
    );
  }
}


class ChatPostCreateView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('대화 글쓰기'),
      ),
      body: Center(
        child: Text('여기에 대화 글쓰기 폼이 들어갑니다.'),
      ),
    );
  }
}

final chatRooms = [
  {
    'avatarUrl': 'https://example.com/avatar1.png',
    'name': '가현',
    'lastMessage': '방탈출 화이팅',
    'time': '14:54',
  },
  {
    'avatarUrl': 'https://example.com/avatar2.png',
    'name': '끼끼',
    'lastMessage': '다음주 방탈출..',
    'time': '10:20',
  },
  // 추가적인 대화방 정보
];
