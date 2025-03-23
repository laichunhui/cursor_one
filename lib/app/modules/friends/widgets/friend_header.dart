import 'package:flutter/material.dart';

class FriendHeader extends StatelessWidget {
  final Function(String) onSearch;
  final VoidCallback onAdd;

  const FriendHeader({super.key, required this.onSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(20),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '我的好友',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: onAdd,
                tooltip: '添加好友',
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            onChanged: onSearch,
            decoration: InputDecoration(
              hintText: '搜索好友',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
