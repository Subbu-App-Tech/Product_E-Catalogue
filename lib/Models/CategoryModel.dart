import 'package:flutter/widgets.dart';

class CategoryModel with ChangeNotifier {
  final String id;
  final String name;
  CategoryModel({
    this.id,
    this.name,
  });
  
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class Categorycount with ChangeNotifier {
  final String id;
  final int count;
  Categorycount({
    @required this.id,
    @required this.count,
  });
}

class Brandcount with ChangeNotifier {
  final String name;
  final int count;
  Brandcount({
    @required this.name,
    @required this.count,
  });
}
