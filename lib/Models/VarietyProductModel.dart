import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'VarietyProductModel.g.dart';

// flutter packages pub run build_runner build
@HiveType(typeId: 1)
class VarietyProductM extends HiveObject {
  @HiveField(0)
  final String productid;
  @HiveField(1)
  final String id;
  @HiveField(2)
  String varityname;
  @HiveField(3)
  double price;
  @HiveField(4)
  double wsp;

  VarietyProductM({
    @required this.productid,
    @required this.id,
    @required this.varityname,
    this.price = 0,
    this.wsp = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productid': productid,
      'name': varityname,
      'price': price,
      'wsp': wsp
    };
  }

  void updatename(name) {
    this.varityname = name;
  }

  void updateprice(double price) {
    this.price = price;
  }

  void updatewsp(double wsp) {
    this.wsp = wsp;
  }

  String getIndex(int index) {
    switch (index) {
      case 0:
        return '$varityname';
      case 1:
        return '${price.toString()}';
      // case 3:
      //   return '${wsp.toString()}';
    }
    return '';
  }
}
