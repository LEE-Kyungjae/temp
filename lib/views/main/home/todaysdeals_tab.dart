import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TodaysDealsTab extends StatelessWidget {
  const TodaysDealsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return FutureBuilder(
      future: fetchTodaysDealsPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || !snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
          return _buildContent(context, screenWidth, []);
        } else {
          final deals = snapshot.data as List<dynamic>;
          return _buildContent(context, screenWidth, deals);
        }
      },
    );
  }

  Future<List<dynamic>> fetchTodaysDealsPosts() async {
    final response = await http.get(Uri.parse('https://your-backend-api/todaysdealspost'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load today\'s deals posts');
    }
  }

  Widget _buildContent(BuildContext context, double screenWidth, List<dynamic> deals) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              '오늘의 프로모션',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: 200,
            child: PageView.builder(
              itemCount: 5,
              itemBuilder: (context, index) {
                final hasData = deals.isNotEmpty;
                final deal = hasData ? deals[index % deals.length] : null;

                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Stack(
                    children: [
                      Container(
                        width: screenWidth - 16,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: hasData
                              ? DecorationImage(
                            image: NetworkImage(deal['imageUrl']),
                            fit: BoxFit.cover,
                          )
                              : null,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: hasData
                              ? Image.network(
                            deal['imageUrl'],
                            fit: BoxFit.cover,
                            width: screenWidth - 16,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey,
                                child: const Icon(Icons.broken_image, color: Colors.white),
                              );
                            },
                          )
                              : Container(
                            color: Colors.grey,
                            child: const Icon(Icons.broken_image, color: Colors.white, size: 100),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          color: Colors.black54.withOpacity(0.7),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Text(
                            '${index + 1}/5',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('내 근처의 오픈을 확인해보세요!'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: deals.isEmpty
                  ? [
                _buildPlaceholderPromotionCard(context),
                _buildPlaceholderPromotionCard(context),
                _buildPlaceholderPromotionCard(context),
                _buildPlaceholderPromotionCard(context),
                _buildPlaceholderPromotionCard(context),
              ]
                  : deals.map<Widget>((deal) => _buildPromotionCard(context, deal)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromotionCard(BuildContext context, dynamic deal) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              deal['imageUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
          title: Text(deal['title']),
          subtitle: Text(deal['subtitle']),
        ),
      ),
    );
  }

  Widget _buildPlaceholderPromotionCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Container(
              color: Colors.grey,
              child: const Icon(Icons.broken_image, color: Colors.white, size: 50),
            ),
          ),
          title: const Text('데이터 없음'),
          subtitle: const Text('현재 프로모션 정보가 없습니다.'),
        ),
      ),
    );
  }
}
