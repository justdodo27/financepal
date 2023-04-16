class Category {
  final int id;
  final String name;
  final int? userId;
  final int? groupId;

  Category({
    required this.id,
    required this.name,
    required this.userId,
    required this.groupId,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'],
        name: json['category'],
        userId: json['user_id'],
        groupId: json['group_id'],
      );
}
