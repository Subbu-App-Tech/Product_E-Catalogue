import 'package:flutter/material.dart';

class ProductModel with ChangeNotifier {
  String id;
  String name;
  String description;
  List imagepathlist;
  int favpic;
  int rank;
  List categorylist;
  String brand;
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
      this.favourite = false});

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
    notifyListeners();
  }

  void toggleFavoriteStatus() {
    favourite = !favourite;
    notifyListeners();
  }

  void updaterank(int rank) {
    this.rank = rank;
    notifyListeners();
  }

  void updatefavimage(int favpic) {
    this.favpic = favpic;
    notifyListeners();
  }

  void updatedescription(description) {
    this.description = description;
    notifyListeners();
  }

  void updateimageurl(imagepath) {
    this.imagepathlist = imagepath;
    notifyListeners();
  }

  void updatebrand(brand) {
    this.brand = brand;
    notifyListeners();
  }
}
