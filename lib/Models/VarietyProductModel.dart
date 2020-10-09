import 'package:flutter/material.dart';

class VarietyProductM with ChangeNotifier {
  final String productid;
  final String id;
  String varityname;
  double price;
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
    notifyListeners();
  }

  void updateprice(double price) {
    this.price = price;
    notifyListeners();
  }

  void updatewsp(double wsp) {
    this.wsp = wsp;
    notifyListeners();
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
