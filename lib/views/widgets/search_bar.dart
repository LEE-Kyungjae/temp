import 'package:exit/providers/post_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final postProvider = Provider.of<PostProvider>(context);

    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
        decoration: InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),

        ),
          onChanged:(value){
            postProvider.searchPosts(value);
          },
        ),
    );
  }
}
