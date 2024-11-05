import 'package:exit/views/main/home/home_view.dart';
import 'package:exit/views/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:exit/views/main/personal/personal_view.dart';
import 'package:exit/views/main/crew/crew_view.dart';
import 'package:exit/views/main/reservation/reservation_view.dart';
import 'package:exit/views/main/chat/community_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  _MainNavigationViewState createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _currentIndex = 2;

  final List<Widget> _children = [
    const CrewView(),
    const CommunityView(),
    const HomeView(),
    const ReservationView(),
    const PersonalView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: onTabTapped,
      ),
    );
  }
}
