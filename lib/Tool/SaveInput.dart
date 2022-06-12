// import 'package:flutter/material.dart';
// import '../Models/Product.dart';
// import '../Models/VarietyProduct.dart';
// import 'package:csv/csv.dart';
// import 'dart:io';
// import 'dart:convert';

// Future savedata(String filepath) async {
//   try {
//     final input = new File(filepath).openRead();
//     final fields = await input
//         .transform(utf8.decoder)
//         .transform(new CsvToListConverter())
//         .toList();
//     List<String> header = [
//       'name',
//       'description',
//       // 'price',
//       'brand',
//       'category',
//       'varietyname',
//       'varietyprice'
//           'varietywsp',
//     ];
//     bool areListsEqual(var list1, var list2) {
//       // check if both are lists
//       if (!(list1 is List && list2 is List)
//           // check if both have same length
//           ||
//           list1.length != list2.length) {
//         return false;
//       }

//       // check if elements are equal
//       for (int i = 0; i < list1.length; i++) {
//         if (list1[i] != list2[i]) {
//           return false;
//         }
//       }

//       return true;
//     }

//     double? doubleval(var input) {
//       if (input == null || input == '' || input.runtimeType == String) {
//         return 0.0;
//       }
//       if (input.runtimeType == double) {
//         return input;
//       }
//       if (input.runtimeType != int) {
//         //error
//       }
//       return input.toDouble();
//     }

//     String? stringval(var input) {
//       if (input == null || input == '') {
//         return null;
//       } else {
//         if (input.runtimeType != String) {
//           return input.toString();
//         } else {
//           return input;
//         }
//       }
//     }

//     bool isequal(Product a, Product b) {
//       if (a.name == b.name &&
//           a.brand == b.brand &&
//           // a.price == a.price &&
//           // a.wsp == b.wsp &&
//           a.description == b.description) {
//         return true;
//       }
//       return false;
//     }

//     bool iscontains(List list, var value) {
//       List v = [];
//       for (var i in list) {
//         v.add(isequal(i, value));
//       }
//       if (v.contains(true)) {
//         return true;
//       }
//       return false;
//     }

//     Future validate(datafield) async {
//       if (areListsEqual(datafield[0], header)) {
//         {
//           List<Product> productdata = [];
//           List<CategoryModel> catdata = [];
//           List<VarietyProductM> vardata = [];
//           List<String> catnamedata = [];

//           for (List i in fields) {
//             if (i[0] == 'name' || i[1] == 'description') {
//             } else {
//               final prodid = UniqueKey().toString();

//               List<String>? catid(String? catstring) {
//                 List<String?> _catid = [];
//                 if (catstring == null || catstring.trim() == '') {
//                   return null;
//                 } else {
//                   for (String i in catstring.split(',')) {
//                     if (catnamedata.contains(i)) {
//                       _catid.add(catdata.firstWhere((f) => f.name == i).name);
//                     } else {
//                       String _cid = UniqueKey().toString();
//                       catnamedata.add(i);
//                       catdata.add(CategoryModel(name: _cid, name: i));
//                       _catid.add(_cid);
//                     }
//                   }
//                   _catid.removeWhere((e) => e == null);
//                   return _catid.map((e) => e!).toList();
//                 }
//               }

//               Product prodmod = Product(
//                   id: prodid.toString(),
//                   name: stringval(i[0]),
//                   brand: stringval(i[2]),
//                   description: stringval(i[1]),
//                   categories: catid(i[3]));

//               if (iscontains(productdata, prodmod)) {
//                 if (i[4] == null || i[4].trim() == '') {
//                 } else {
//                   vardata.add(VarietyProductM(
//                       productid:
//                           productdata.firstWhere((f) => isequal(f, prodmod)).id,
//                       id: UniqueKey().toString(),
//                       name: stringval(i[4]),
//                       price: doubleval(i[5]),
//                       wsp: doubleval(i[6])));
//                 }
//               } else {
//                 productdata.add(prodmod);
//                 vardata.add(VarietyProductM(
//                     productid: prodid.toString(),
//                     id: UniqueKey().toString(),
//                     name: stringval(i[4]),
//                     price: doubleval(i[5]),
//                     wsp: doubleval(i[6])));
//               }
//             }
//             // print(vardata.length);
//             // print(catdata.length);
//             // print(productdata.length);
//             // print('-----------------');
//           }
//         }

//         return Text('Saved');
//       } else {
//         return Text('Error'); //error in column header
//       }
//     }

//     validate(fields);
//   } catch (e) {
//     return 0;
//   }
// }

// // savedata('assets/CatalogueTemplate.csv');
