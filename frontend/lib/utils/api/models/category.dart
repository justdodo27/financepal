class Category {
  final int? id;
  String name;
  final int? userId;
  final int? groupId;

  bool get isUserCategory => userId != null;
  bool get isGroupCategory => groupId != null;
  bool get isGeneralCategory => groupId == null && userId == null;

  Category({
    this.id,
    required this.name,
    this.userId,
    this.groupId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['category'],
        userId: json['user_id'],
        groupId: json['group_id'],
      );
}
