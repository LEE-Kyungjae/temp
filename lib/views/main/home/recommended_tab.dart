import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecommendedTab extends StatelessWidget {
  const RecommendedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchRecommendedPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final stores = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: stores.length,
            itemBuilder: (context, index) {
              return _buildStoreCard(context, stores[index]);
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchRecommendedPosts() async {
    final response = await http.get(Uri.parse('https://your-backend-api/recommendedpost'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load recommended posts');
    }
  }

  Widget _buildStoreCard(BuildContext context, dynamic store) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              store['imageUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
          title: Text(store['title']),
          subtitle: Text(store['description']),
        ),
      ),
    );
  }
}
