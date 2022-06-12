import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import 'package:productcatalogue/export.dart';

part 'Product.g.dart';

class Count {
  String? name;
  int count;
  Count({this.name, required this.count});
}

@HiveType(typeId: 0)
class Product extends HiveObject {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(3)
  String? description;
  @HiveField(4)
  List<String> imagepathlist;
  @HiveField(5)
  int? favpic;
  @HiveField(6)
  int? rank;
  @HiveField(7)
  List<String> categories = [];
  @HiveField(8)
  String? brand;
  @HiveField(9)
  bool favourite = false;
  @HiveField(10)
  List<VarietyProductM> varieties = [];

  Product(
      {required this.id,
      required this.name,
      this.favpic = 0,
      this.rank = 0,
      required this.imagepathlist,
      this.brand,
      required this.categories,
      this.description,
      this.favourite = false});

  String? lsttostring(List? vallist) {
    if (vallist == null) {
      return null;
    } else {
      return vallist.join(',');
    }
  }

  bool isequal(Product a, Product b) {
    if (a.name == b.name &&
        a.description == b.description &&
        a.brand == b.brand &&
        a.categories == b.categories) {
      return true;
    }
    return false;
  }

  void updatename(name) {
    this.name = name;
  }

  void toggleFavoriteStatus() {
    favourite = !favourite;
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

  void addEmptyVariety() {
    this.varieties.add(VarietyProductM(
        productid: id,
        id: '${id}_${UniqueKey()}_${DateTime.now().microsecondsSinceEpoch}',
        name: '',
        price: 0,
        wsp: 0));
  }

  void addCategIfNotExist(String categ) {
    if (!categories.contains(categ)) categories.add(categ);
  }

  void addRemoveCateg(String categ) {
    if (!categories.contains(categ)) {
      categories.add(categ);
    } else {
      categories.remove(categ);
    }
  }

  static List<String> get header => [
        'name',
        'brand',
        'description',
        'category',
        'varietyname',
        'varietyprice',
        'varietywsp',
        'rank',
        'imagefilename'
      ];

  List<List> get toList => varieties
      .map((e) => [
            name,
            brand,
            description,
            categories.join(','),
            e.name,
            e.price,
            e.wsp,
            rank,
            imagepathlist.join(',')
          ])
      .toList();

  List<double> get minMaxPrice {
    varieties.sort((a, b) => a.price.compareTo(b.price));
    return varieties.length == 0
        ? [0, 0]
        : [varieties.first.price, varieties.last.price];
  }
}
