import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';

part 'CategoryModel.g.dart';

@HiveType(typeId: 3)
class CategoryModel with ChangeNotifier {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  CategoryModel({
    this.id,
    this.name,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}

class Categorycount with ChangeNotifier {
  final String? id;
  final int count;
  Categorycount({
    required this.id,
    required this.count,
  });
}

class Brandcount with ChangeNotifier {
  final String? name;
  final int count;
  Brandcount({
    required this.name,
    required this.count,
  });
}
