// import 'package:collection/collection.dart' show IterableExtension;
// import 'package:flutter/material.dart';
// import '../Models/CategoryModel.dart';
// import 'package:hive/hive.dart';

// class CategoryData with ChangeNotifier {
//   List<CategoryModel> _items = [];
//   late Box<CategoryModel> _dbbox;

//   CategoryData() {
//     _dbbox = Hive.box<CategoryModel>('CategoryModel');
//     _items = [..._dbbox.values];
//   }
//   List<CategoryModel> get items => [..._items];

//   List<String?> itemid() {
//     List<String?> _val = [];
//     for (CategoryModel i in _items) {
//       _val.add(i.id);
//     }
//     return _val;
//   }

//   void delete(String? catid) {
//     _items.removeWhere((ele) => ele.id == catid);
//     _dbbox.delete(catid);
//   }

//   void deleteall() {
//     _items = [];
//     _dbbox.deleteAll(_dbbox.keys);
//     return null;
//   }

//   String? findcategorynamebyid(String id) {
//     return _items.firstWhere((element) => element.id == id).name;
//   }

//   List<String> findcategorylist(List<String?>? categorylist) {
//     List<String> _lst = [];
//     String? s;
//     categorylist == null ? categorylist = [] : categorylist
//       ..remove('');
//     if (categorylist.length > 0) {
//       for (String? i in categorylist) {
//         if (i == 'otherid') {
//           s = null;
//         } else {
//           s = _items.firstWhereOrNull((cat) => cat.id == i)?.name ?? '';
//         }
//         s == null ? _lst = [] : _lst.add(s);
//       }
//       return [..._lst];
//     } else {
//       return [];
//     }
//   }

//   List<String> catnamelist() {
//     List<String?> catnamelist = items.map((e) => e.name).toList();
//     catnamelist.removeWhere((e) => e == null);
//     return catnamelist.map((e) => e!).toList();
//   }

//   List<String> findidlist(List<String> namelist) {
//     List<String> lst = [];
//     List<CategoryModel> modlist = [];
//     for (String i in namelist) {
//       modlist.addAll(_items.where((element) => element.name == i));
//     }
//     for (CategoryModel i in modlist) {
//       if (i.id != null) lst.add(i.id!);
//     }
//     return lst;
//   }

//   List<String> findcategoryidlist(List<String?> categoryvaluelist) {
//     List _lst = [];
//     for (String? i in categoryvaluelist) {
//       String? s = _items.firstWhere((cat) => cat.name == i).id;
//       s == null ? _lst = [] : _lst.add(s);
//     }
//     return [..._lst];
//   }

//   Future addallcategory(List<CategoryModel> list) async {
//     await _dbbox.putAll(Map.fromEntries(list.map((e) => MapEntry(e.id, e))));
//     notifyListeners();
//   }

//   Future addcategory(String categoryname) async {
//     String _id = UniqueKey().toString();
//     final newcat = CategoryModel(id: _id, name: categoryname);
//     await _dbbox.put(newcat.id.toString(), newcat);
//     _items.add(newcat);
//   }
// }
