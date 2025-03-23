import 'package:cursor_one/app/modules/friends/model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'friends_controller.dart';
import 'widgets/friend_item.dart';
import 'widgets/friend_header.dart';

class FriendsView extends GetView<FriendsController> {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('好友列表'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            FriendHeader(
              onSearch: controller.searchFriends,
              onAdd: () => _showAddFriendDialog(context),
            ),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                final friends = controller.filteredFriends;

                if (friends.isEmpty) {
                  return Center(
                    child: Text(
                      controller.searchQuery.isEmpty ? '暂无好友' : '未找到相关好友',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadFriends,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      final friend = friends[index];
                      return FriendItem(
                        friend: friend,
                        onTap: () => _showFriendDetails(context, friend),
                        onRemove: () => controller.removeFriend(friend.id),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddFriendDialog(BuildContext context) {
    final TextEditingController textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text('添加好友'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: '输入好友ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.addFriend(textController.text.trim());
                Get.back();
              }
            },
            child: const Text('添加'),
          ),
        ],
      ),
    );
  }

  void _showFriendDetails(BuildContext context, FriendModel friend) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(friend.avatar),
            ),
            const SizedBox(height: 16),
            Text(
              friend.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              friend.status,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.chat,
                  label: '发消息',
                  onTap: () {
                    Get.back();
                    // 跳转到聊天页面
                  },
                ),
                _buildActionButton(
                  icon: Icons.videocam,
                  label: '视频通话',
                  onTap: () {
                    Get.back();
                    // 发起视频通话
                  },
                ),
                _buildActionButton(
                  icon: Icons.delete,
                  label: '删除',
                  color: Colors.redAccent,
                  onTap: () {
                    Get.back();
                    controller.removeFriend(friend.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: color.withOpacity(0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: color)),
        ],
      ),
    );
  }
}
