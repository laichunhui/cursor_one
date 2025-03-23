class FriendModel {
  final String id;
  final String name;
  final String avatar;
  final String status;
  final bool isOnline;
  final DateTime lastActive;

  FriendModel({
    required this.id,
    required this.name,
    required this.avatar,
    required this.status,
    required this.isOnline,
    required this.lastActive,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      status: json['status'] as String,
      isOnline: json['isOnline'] as bool,
      lastActive: DateTime.parse(json['lastActive'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'status': status,
      'isOnline': isOnline,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}
