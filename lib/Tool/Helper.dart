// import 'package:flutter/material.dart';
import '../Models/Product.dart';

class Helper {
  double? doubleval(var input) {
    if (input == null || input == '') {
      return 1.0;
    } else if (input.runtimeType == double) {
      return input;
    } else if (input.runtimeType == int) {
      return input.toDouble();
    } else {
      return 1.0;
    }
  }

  int intval(var input) {
    if (input == null || input == '') {
      return 1000;
    } else if (input.runtimeType == double) {
      return int.parse(input);
    } else if (input.runtimeType == int) {
      return input;
    } else {
      return 1000;
    }
  }

  bool areListsEqual(var list1, var list2) {
    if (!(list1 is List && list2 is List) || list1.length != list2.length) {
      return false;
    }
    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) {
        return false;
      }
    }
    return true;
  }

  String stringval(var input) {
    if (input == null || input.trim() == '') {
      return '';
    } else {
      if (input.runtimeType != String) {
        return input.toString();
      } else {
        return input.trim();
      }
    }
  }

  bool isequal(Product a, Product b) {
    if (a.name == b.name &&
        a.brand == b.brand &&
        // a.price == a.price &&
        a.description == b.description &&
        areListsEqual(a.categories, b.categories)) {
      return true;
    }
    return false;
  }

  bool iscontains(List list, var value) {
    List v = [];
    for (var i in list) {
      v.add(isequal(i, value));
    }
    if (v.contains(true)) {
      return true;
    }
    return false;
  }
}
