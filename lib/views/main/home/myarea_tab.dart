import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyAreaTab extends StatelessWidget {
  const MyAreaTab({super.key});


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMyAreaPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final localPosts = snapshot.data as List<dynamic>;
          return ListView.builder(
            itemCount: localPosts.length,
            itemBuilder: (context, index) {
              return _buildLocalPostCard(context, localPosts[index]);
            },
          );
        }
      },
    );
  }

  Future<List<dynamic>> fetchMyAreaPosts() async {
    final response = await http.get(Uri.parse('https://your-backend-api/myareapost'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load local posts');
    }
  }

  Widget _buildLocalPostCard(BuildContext context, dynamic post) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
          leading: SizedBox(
            width: 100,
            height: 100,
            child: Image.network(
              post['imageUrl'],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey,
                  child: const Icon(Icons.broken_image, color: Colors.white),
                );
              },
            ),
          ),
          title: Text(post['title']),
          subtitle: Text(post['description']),
        ),
      ),
    );
  }
}
