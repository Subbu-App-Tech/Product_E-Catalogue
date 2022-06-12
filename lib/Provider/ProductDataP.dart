import 'package:productcatalogue/export.dart';
import 'package:flutter/material.dart';
export '../export.dart';
import 'package:hive/hive.dart';

class ProductData with ChangeNotifier {
  List<Product> _items = [];
  late Box<Product> _dbbox;
  ProductData() {
    _dbbox = Hive.box<Product>('Product');
    _items = [...(_dbbox.values)];
  }

  void deleteall() {
    _items = [];
    _dbbox.deleteAll(_dbbox.keys);
  }

  List<Product> get items => [..._items];

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.favourite).toList();
  }

  Product? findbyid(String? id) {
    return _items.firstWhereOrNull((prd) => prd.id == id);
  }

  String? lsttostring(List vallist) {
    if (vallist.length <= 0) {
      return null;
    } else {
      return vallist.join(',');
    }
  }

  List<Product> findbybrand(String? brandname) {
    return [..._items.where((e) => e.brand == brandname)];
  }

  void addallproduct(List<Product> list) {
    // _items.addAll(list);
    for (var i in list) {
      addproduct(i);
    }
    notifyListeners();
  }

  bool tog(bool? val) {
    if (val == true) {
      return false;
    } else {
      return true;
    }
  }

  Future toggleFavoriteStatus(Product product) async {
    product.toggleFavoriteStatus();
    final prodindex = _items.indexWhere((p) => p.id == product.id);
    _items[prodindex] = product;
    await _dbbox.put(product.id.toString(), product);
    notifyListeners();
  }

  Future deleteproduct(String? id) async {
    _items.removeWhere((p) => p.id == id);
    await _dbbox.delete(id);
    notifyListeners();
  }

  List<String> get uqCategList {
    List<String> totalcat = [];
    _items.forEach((w) => totalcat.addAll(w.categories));
    return totalcat.toSet().toList();
  }

  List<Count> get categCountList {
    List<Count> rst = [];
    List<String> totalcat = [];
    _items.forEach((w) => totalcat.addAll(w.categories));
    for (String i in uqCategList) {
      rst.add(Count(name: i, count: totalcat.where((f) => f == i).length));
    }
    return rst;
  }

  List<Count> get uqBrand {
    List<Count> rst = [];
    List<String?> totalbrand = _items.map((e) => e.brand).toList();
    List<String?> uniqval = totalbrand.toSet().toList();
    for (String? i in uniqval) {
      rst.add(Count(count: totalbrand.where((f) => f == i).length));
    }
    return rst;
  }

  List<Product> prodListByCateg(String? catId) {
    return [..._items.where((f) => (f.categories).contains(catId))];
  }

  List<Product> prodListByBrand(String? name) {
    return [..._items.where((f) => f.brand == name)];
  }

  bool bolval(String val) {
    if (val == true.toString()) {
      return true;
    }
    return false;
  }

  List<String> get uqBrandList {
    List<String> uniqval = _items.map((e) => e.brand ?? '').toSet().toList();
    uniqval.remove('');
    return uniqval;
  }

  List<String>? stringtolist(String? val) {
    if (val.runtimeType == String && val != 'null') {
      return val!.split(',');
    }
    return null;
  }

  Future addproduct(Product data) async {
    final prodindex = _items.indexWhere((p) => p.id == data.id);
    if (prodindex >= 0) {
      _items[prodindex] = data;
    } else {
      _items.add(data);
    }
    await _dbbox.put(data.id.toString(), data);
    notifyListeners();
  }
}
