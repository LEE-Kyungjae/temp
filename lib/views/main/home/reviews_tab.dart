import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReviewsTab extends StatelessWidget {
  const ReviewsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchReviewsPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final reviews = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return _buildReviewCard(context, reviews[index]);
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchReviewsPosts() async {
    final response = await http.get(Uri.parse('https://your-backend-api/reviewspost'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load reviews posts');
    }
  }

  Widget _buildReviewCard(BuildContext context, dynamic review) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              review['imageUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
          title: Text(review['title']),
          subtitle: Text(review['description']),
        ),
      ),
    );
  }
}
