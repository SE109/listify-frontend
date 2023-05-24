import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Card(
        elevation: 1,
        child: TextField(
          enabled: false,
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search_rounded),
          ),
        ),
      ),
    );
  }
}
