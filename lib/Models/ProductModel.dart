import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'ProductModel.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(3)
  String description;
  @HiveField(4)
  List imagepathlist;
  @HiveField(5)
  int favpic;
  @HiveField(6)
  int rank;
  @HiveField(7)
  List categorylist;
  @HiveField(8)
  String brand;
  @HiveField(9)
  bool favourite;

  ProductModel(
      {@required this.id,
      @required this.name,
      this.favpic = 0,
      this.rank = 0,
      this.imagepathlist,
      this.brand,
      this.categorylist,
      this.description,
      this.favourite});

  String lsttostring(List vallist) {
    if (vallist == null) {
      return null;
    } else {
      return vallist.join(',');
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageurl': lsttostring(imagepathlist),
      'rank': rank,
      'catlist': lsttostring(categorylist),
      'brand': brand,
      'fav': favourite.toString()
    };
  }

  bool isequal(ProductModel a, ProductModel b) {
    if (a.name == b.name &&
        a.description == b.description &&
        a.brand == b.brand &&
        a.categorylist == b.categorylist) {
      return true;
    }
    return false;
  }

  void updatename(name) {
    this.name = name;
  }

  void toggleFavoriteStatus() {
    favourite = !(favourite ?? false);
  }

  void updaterank(int rank) {
    this.rank = rank;
  }

  void updatefavimage(int favpic) {
    this.favpic = favpic;
  }

  void updatedescription(description) {
    this.description = description;
  }

  void updateimageurl(imagepath) {
    this.imagepathlist = imagepath;
  }

  void updatebrand(brand) {
    this.brand = brand;
  }

}
