import '../Models/ProductModel.dart';
import 'package:flutter/material.dart';
import '../Models/CategoryModel.dart';
import '../Tool/DB_Helper.dart';
export '../Models/ProductModel.dart';
// import 'dart:io';
import 'package:hive/hive.dart';

class ProductData with ChangeNotifier {
  List<ProductModel> _items = [];
  Box<ProductModel> _dbbox;
  ProductData(Box<ProductModel> db) {
    _dbbox = db;
    _items = [...(_dbbox?.values ?? [])];
  }

  void deleteall() {
    DBHelper.deleteall('product_data');
    _items = [];
    _dbbox.deleteAll(_dbbox.keys);
    return null;
  }

  List<ProductModel> get items {
    return [..._items];
  }

  List<ProductModel> get favoriteItems {
    return _items.where((prodItem) => prodItem.favourite ?? false).toList() ??
        [];
  }

  ProductModel findbyid(String id) {
    return _items.firstWhere((prd) => prd.id == id, orElse: () => null);
  }

  String lsttostring(List vallist) {
    if (vallist == null || vallist.length <= 0) {
      return null;
    } else {
      return vallist.join(',');
    }
  }

  List<ProductModel> findbybrand(String brandname) {
    return [..._items.where((e) => e.brand == brandname)];
  }

  void addallproduct(List<ProductModel> list) {
    // _items.addAll(list);
    for (var i in list) {
      addproduct(i);
    }
    notifyListeners();
  }

  void editproduct(String id, ProductModel newdata) {
    final prodindex = _items.indexWhere((p) => p.id == id);
    if (prodindex >= 0) {
      _items[prodindex] = newdata;
      // DBHelper.updateData('product_data', newdata);
      _dbbox.put(newdata.id.toString(), newdata);
      notifyListeners();
    } else {}
  }

  bool tog(bool val) {
    if (val == true) {
      return false;
    } else {
      return true;
    }
  }

  void toggleFavoriteStatus(ProductModel product) {
    product.toggleFavoriteStatus();
    final prodindex = _items.indexWhere((p) => p.id == product.id);
    ProductModel newdata = ProductModel(
        id: product.id,
        name: product.name,
        brand: product.brand,
        categorylist: product.categorylist,
        description: product.description,
        imagepathlist: product.imagepathlist,
        favourite: tog(product.favourite));
    _items[prodindex] = newdata;
    _dbbox.put(newdata.id.toString(), newdata);
    // DBHelper.updateData('product_data', newdata);
    notifyListeners();
  }

  void deleteproduct(String id) {
    _items.removeWhere((p) => p.id == id);
    DBHelper.delete('product_data', id);
    _dbbox.delete(id);
    notifyListeners();
  }

  List<String> uqcatidlist() {
    List<String> totalcat = [];
    for (var i in _items) {
      if (i.categorylist != null) {
        for (var j in i.categorylist) {
          totalcat.add(j);
        }
      }
    }
    return totalcat.toSet().toList();
  }

  List<Categorycount> categorycountlist() {
    List<Categorycount> rst = [];
    List<String> totalcat = [];
    List<int> valcount = [];
    for (var i in _items) {
      if (i.categorylist != null) {
        for (var j in i.categorylist) {
          totalcat.add(j);
        }
      }
    }
    List<String> uniqval = totalcat.toSet().toList();
    for (String i in uniqval) {
      valcount.add(totalcat.where((f) => f == i).length);
    }
    if (uniqval.length != valcount.length) {
      return [];
    }
    for (int i = 0; i < (uniqval.length); i++) {
      rst.add(Categorycount(id: uniqval[i], count: valcount[i]));
    }
    return rst;
  }

  List<Brandcount> uqbrand() {
    List<Brandcount> rst = [];
    List<String> totalbrand = [];
    List<int> valcount = [];
    for (var i in _items) {
      if (i.brand != null) {
        totalbrand.add(i.brand);
      }
    }

    List<String> uniqval = totalbrand.toSet().toList();
    uniqval.remove('');
    for (String i in uniqval) {
      valcount.add(totalbrand.where((f) => f == i).length);
    }
    if (uniqval.length != valcount.length) {
      return [];
    }
    for (int i = 0; i < (uniqval.length); i++) {
      rst.add(Brandcount(name: uniqval[i], count: valcount[i]));
    }
    return rst;
  }

  List<ProductModel> productlistbycatid(String id) {
    if (id == null || id == 'null') {
      return [];
    } else {
      return [
        ..._items.where((f) =>
            (f.categorylist != null) ? f.categorylist.contains(id) : false)
      ];
    }
  }

  List<ProductModel> productlistbybrandname(String name) {
    return [..._items.where((f) => f.brand == name)];
  }

  bool bolval(String val) {
    if (val == true.toString()) {
      return true;
    }
    return false;
  }

  List<String> brandlist() {
    List<String> totalbrand = [];
    for (var i in _items) {
      if (i.brand != null) {
        totalbrand.add(i.brand);
      }
    }
    List<String> uniqval = totalbrand.toSet().toList();
    uniqval.remove('');
    return uniqval;
  }

  List stringtolist(String val) {
    if (val.runtimeType == String && val != 'null') {
      return val.split(',');
    }
    return null;
  }

  Future<void> addproduct(ProductModel data) async {
    _items.add(data);
    _dbbox.put(data.id.toString(), data);
    // DBHelper.insert('product_data', {
    //   'id': data.id,
    //   'name': data.name,
    //   'description': data.description,
    //   'imageurl': lsttostring(data.imagepathlist),
    //   'rank': data.rank,
    //   // 'wsp': data.wsp,
    //   'catlist': lsttostring(data.categorylist),
    //   'brand': data.brand,
    //   'fav': data.favourite.toString()
    // });
    notifyListeners();
  }

  Future<void> fetchproduct() async {
    if (_dbbox.keys.length == 0) {
      final dataList = await DBHelper.getData('product_data');
      _items = dataList
          .map(
            (item) => ProductModel(
              id: item['id'],
              name: item['name'],
              description: item['description'],
              imagepathlist: stringtolist(item['imageurl']),
              rank: item['rank'],
              brand: item['brand'],
              favourite: bolval(item['fav']),
              categorylist: stringtolist(item['catlist']),
            ),
          )
          .toList();
      _items.forEach((e) {
        _dbbox.put(e.id.toString(), e);
      });
    }
    _items = [];
    _items = [...(_dbbox?.values ?? [])];
    notifyListeners();
  }
}
