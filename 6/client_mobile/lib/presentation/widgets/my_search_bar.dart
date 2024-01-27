import 'package:flutter/material.dart';

class MySearchBar extends StatelessWidget {
  const MySearchBar({
    super.key,
    required this.searchController,
    required this.onSearched,
    this.hintText,
  });

  final TextEditingController searchController;
  final VoidCallback onSearched;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 250,
          height: 60,
          child: TextField(
            onSubmitted: (value) => onSearched(),
            decoration: InputDecoration(hintText: hintText),
            controller: searchController,
          ),
        ),
        IconButton(
          onPressed: onSearched,
          icon: const Icon(Icons.search),
        ),
      ],
    );
  }
}
