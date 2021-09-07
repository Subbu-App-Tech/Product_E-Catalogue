import 'package:flutter/material.dart';
import '../Models/VarietyProductModel.dart';
import 'package:hive/hive.dart';

class VarietyData with ChangeNotifier {
  List<VarietyProductM> _items = [];
  Box<VarietyProductM>? _dbbox;

  VarietyData(Box<VarietyProductM>? db) {
    _dbbox = db;
    _items = [..._dbbox!.values];
  }
  List<VarietyProductM> get items {
    return [..._items];
  }

  void deleteall() {
    // DBHelper.deleteall('varietydata');
    _items = [];
    _dbbox!.deleteAll(_dbbox!.keys);
    return null;
  }

  List<VarietyProductM> findbyid(String? productid) {
    return [..._items.where((vp) => vp.productid == productid)];
  }

  String changenullstring(String? val) {
    if (val == null) {
      return '';
    } else
      return val;
  }

  double changenulldouble(double? val) {
    if (val == null) {
      return 0;
    } else
      return val;
  }

  String vartext(String? productid) {
    List<VarietyProductM> _vartylist = [
      ..._items.where((vp) => vp.productid == productid)
    ];
    List<String> _varlst = [];
    for (VarietyProductM i in _vartylist) {
      _varlst.add('${changenullstring(i.varityname)},'
          ' ${changenulldouble(i.price)}, '
          '${changenulldouble(i.wsp)} ');
    }
    return _varlst.join('\n');
  }

  int findvarietycount(String productid) {
    return [..._items.where((vp) => vp.productid == productid)].length;
  }

  List<double>? minmaxvalue(String? productid) {
    List<double> value = [];
    for (VarietyProductM i in findbyid(productid)) {
      value.add(i.price ?? 0);
    }
    if (value.length == 0) {
      return null;
    } else {
      value.sort();
      return [value.first, value.last];
    }
  }

  List<double?> sortedpricelist() {
    List<double?> price = [];
    for (VarietyProductM i in _items) {
      price.add(i.price);
    }
    price..sort();
    return price;
  }

  void addallvarity(List<VarietyProductM> list) {
    addvariety(list);
    notifyListeners();
  }

  void addvariety(List<VarietyProductM> varietylist) async {
    List<String> prodIds = varietylist.map((e) => e.productid!).toList();
    List<String?> toDelIds = _items
        .where((e) => prodIds.contains(e.productid))
        .map((e) => '${e.id}')
        .toList();
    print('$prodIds | To Del :: $toDelIds');
    await _dbbox!.deleteAll(toDelIds);
    _items.removeWhere((e) => toDelIds.contains('${e.id}'));
    if (varietylist.length > 0) {
      int ii = 0;
      for (VarietyProductM i in varietylist) {
        ii++;
        if (i.varityname != null) {
          String ke = UniqueKey().toString().substring(2, 6);
          print('>>>>---${i.id} ---->>>');
          String id = i.id?.toString() ??
              '${DateTime.now().millisecondsSinceEpoch}_$ii$ke';
          id.replaceAll('#', '');
          id.replaceAll('[', '');
          id.replaceAll(']', '');
          VarietyProductM varit = VarietyProductM(
              productid: i.productid,
              id: id,
              varityname: i.varityname,
              price: i.price,
              wsp: i.wsp);
          _items.add(varit);
          await _dbbox!.put(id, varit);
        }
      }
    }
    notifyListeners();
  }

  Future<void> fetchvariety() async {
    _items = [];
    _items = [...(_dbbox?.values ?? [])];
    notifyListeners();
  }

  void editvariety(List<VarietyProductM> varietylist) async {
    if (varietylist.length > 0) {
      List<String> delids = _items
          .where((ele) => ele.productid == varietylist[0].productid)
          .map((e) => e.id ?? '')
          .toList();
      await _dbbox?.deleteAll(delids);
      _items.removeWhere((e) => delids.contains(e.id));
      addvariety(varietylist);
    }
    notifyListeners();
  }

  void delete(String? productid) {
    _items.removeWhere((ele) => ele.productid == productid);
    _dbbox!.delete(
        _dbbox!.values.where((e) => e.productid == productid).map((e) => e.id));
  }
}
