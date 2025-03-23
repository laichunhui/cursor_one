import 'package:get/get.dart';
import 'model.dart';

class FriendsController extends GetxController {
  final RxList<FriendModel> friends = <FriendModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadFriends();
  }

  Future<void> loadFriends() async {
    try {
      isLoading.value = true;

      // 模拟网络请求延迟
      await Future.delayed(const Duration(seconds: 1));

      // 模拟好友数据
      final mockFriends = [
        FriendModel(
          id: '1',
          name: '张三',
          avatar: 'https://randomuser.me/api/portraits/men/1.jpg',
          status: '在线',
          isOnline: true,
          lastActive: DateTime.now(),
        ),
        FriendModel(
          id: '2',
          name: '李四',
          avatar: 'https://randomuser.me/api/portraits/women/2.jpg',
          status: '离线',
          isOnline: false,
          lastActive: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        FriendModel(
          id: '3',
          name: '王五',
          avatar: 'https://randomuser.me/api/portraits/men/3.jpg',
          status: '忙碌中',
          isOnline: true,
          lastActive: DateTime.now(),
        ),
        FriendModel(
          id: '4',
          name: '赵六',
          avatar: 'https://randomuser.me/api/portraits/women/4.jpg',
          status: '离线',
          isOnline: false,
          lastActive: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      friends.value = mockFriends;
    } catch (e) {
      Get.snackbar('错误', '加载好友列表失败: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void searchFriends(String query) {
    searchQuery.value = query;
  }

  List<FriendModel> get filteredFriends {
    if (searchQuery.isEmpty) {
      return friends;
    }
    return friends
        .where(
          (friend) =>
              friend.name.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void addFriend(String friendId) {
    // 实现添加好友逻辑
    Get.snackbar('成功', '已发送好友请求');
  }

  void removeFriend(String friendId) {
    // 实现删除好友逻辑
    Get.snackbar('成功', '已删除好友');
    friends.removeWhere((friend) => friend.id == friendId);
  }
}
