import 'package:flutter/material.dart';
import 'dart:math' as math;

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          icon: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: const Icon(Icons.groups),
          ),
          label: '크루',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: '채팅',
        ),

        const BottomNavigationBarItem(
          icon: Icon(Icons.directions_run),
          label: '탈출',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.calendar_month_outlined),
          label: '예약',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '나',
        ),
      ],
      currentIndex: currentIndex,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      unselectedLabelStyle: const TextStyle(fontSize: 12),
      onTap: onTap,
    );
  }
}
