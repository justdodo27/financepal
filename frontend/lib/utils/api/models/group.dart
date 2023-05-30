import 'category.dart';
import 'payment.dart';
import 'user.dart';

class Group {
  final int id;
  final String name;
  final String code;
  final User author;
  final List<Category> categories;
  final List<Payment> payments;
  final List<User> members;

  Group({
    required this.id,
    required this.name,
    required this.code,
    required this.author,
    required this.categories,
    required this.payments,
    required this.members,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      code: json['group_code'],
      author: User.fromJson(json['author']),
      categories: List<Category>.from(
        json['categories'].map((category) => Category.fromJson(category)),
      ),
      payments: List<Payment>.from(
        json['payments'].map((payment) => Payment.fromJson(payment)),
      ),
      members: List<User>.from(
        json['members'].map((member) => User.fromJson(member)),
      ),
    );
  }
}
