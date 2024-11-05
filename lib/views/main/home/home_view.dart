import 'package:exit/views/main/home/myarea_tab.dart';
import 'package:exit/views/main/home/recommended_tab.dart';
import 'package:exit/views/main/home/todaysdeals_tab.dart';
import 'package:flutter/material.dart';
import 'reviews_tab.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black54,
          bottom: const TabBar(
            tabs: [
              Tab(text: '오늘의 혜택'),
              Tab(text: '추천점포'),
              Tab(text: '내지역'),
              Tab(text: '리뷰'),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
          ),
        ),
        body: const TabBarView(
          children: [
            TodaysDealsTab(),
            RecommendedTab(),
            MyAreaTab(),
            ReviewsTab(),
          ],
        ),
      ),
    );
  }
}
