import 'package:flutter/material.dart';
// import 'package:getflutter/getflutter.dart';
import '../Models/VarietyProductModel.dart';
import '../Models/ProductModel.dart';
import '../Screens/ProductDetails.dart';
import 'dart:io';
import '../Provider/VarietyDataP.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';
import '../Models/SecureStorage.dart';
import 'package:carousel_pro/carousel_pro.dart';

class ProductListBox extends StatefulWidget {
  final ProductModel product;
  ProductListBox({this.product});

  @override
  _ProductListBoxState createState() => _ProductListBoxState();
}

class _ProductListBoxState extends State<ProductListBox> {
  String currency = '';
  SecureStorage storage = SecureStorage();
  List<String> categorylist = [];
  List<VarietyProductM> selectedvariety;
  List<VarietyProductM> varietylist = [];
  // bool _sortAsc;
  // int _sortColumnIndex;
  // bool _sortnameAsc;
  // bool _sortpriceAsc;
  // bool _sortwspAsc;
  String varietydetails;
  String text;
  bool isexpand;

  @override
  void initState() {
    // _sortAsc = false;
    isexpand = false;
    varietydetails = '';
    selectedvariety = [];
    // _sortColumnIndex = 0;
    // _sortpriceAsc = false;
    // _sortnameAsc = false;
    // _sortwspAsc = false;
    currencyset();
    setState(() {});
    super.initState();
  }

  void currencyset() async {
    currency = await storage.getcurrency();
  }

  @override
  void didChangeDependencies() {
    varietylist = Provider.of<VarietyData>(context).findbyid(widget.product.id);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final varietyrange =
        Provider.of<VarietyData>(context).minmaxvalue(widget.product.id);
    final varietycount =
        Provider.of<VarietyData>(context).findbyid(widget.product.id);
    List<String> validimagepath(List<String> pathlist) {
      List<String> valid = [];
      for (String i in pathlist) {
        if (File(i).existsSync()) {
          valid.add(i);
        }
      }
      return valid;
    }

    if (currency == null) {
      currency = '';
    }
    bool checkimagepath(List<String> imagelist) {
      if (imagelist == null) {
        return false;
      } else {
        if (imagelist.length > 0) {
          if (validimagepath(imagelist).length > 0) {
            return true;
          }
        }
        return false;
      }
    }

    List imagefilelist(List<String> pathlist) {
      List image = [];
      for (String i in validimagepath(pathlist)) {
        image.add(FileImage(File(i)));
      }
      return image;
    }

    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ProductDetails(widget.product?.id)));
        },
        child: Column(
          children: [
            Container(
              child: Stack(
                children: [
                  Card(
                    elevation: 2,
                    child: Container(
                      alignment: Alignment.center,
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(3, 2, 3, 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(2.5),
                            child: checkimagepath(widget?.product?.imagepathlist?.cast<String>() ?? [])
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    alignment: Alignment.center,
                                    height: 80,
                                    width: 80,
                                    child: Carousel(
                                      images: imagefilelist(
                                          widget.product.imagepathlist.cast<String>() ?? []),
                                      dotSize: 3,
                                      dotSpacing: 5,
                                      dotColor: Colors.white,
                                      indicatorBgPadding: 5.0,
                                      dotBgColor: Colors.black26,
                                      borderRadius: true,
                                      boxFit: BoxFit.contain,
                                    )
                                    // Image.file(File(validimagepath(
                                    //     widget.product.imagepathlist)[0]))
                                    )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        border:
                                            Border.all(color: Colors.black87),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    alignment: Alignment.center,
                                    height: 80,
                                    width: 80,
                                    child: Text(
                                      'No Image',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                          ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 3),
                                Container(
                                  width: double.infinity,
                                  child: Text(
                                    widget.product.name ?? '',
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.fade,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  child: (varietyrange == null ||
                                          varietyrange.length == 0)
                                      ? Text(
                                          '${currency.toUpperCase()} 0',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : (varietyrange[0] == varietyrange[1])
                                          ? Text(
                                              '${currency.toUpperCase()} ${varietyrange[0].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : Text(
                                              '${currency.toUpperCase()} ${varietyrange[0].toStringAsFixed(2)} - ${varietyrange[1].toStringAsFixed(2)}',
                                              overflow: TextOverflow.clip,
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                ),
                                SizedBox(height: 7),
                                (widget.product.brand == null ||
                                        widget.product.brand == '')
                                    ? SizedBox.shrink()
                                    : FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          'Brand: ${widget.product.brand}',
                                          style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.black54),
                                        ),
                                      ),
                                (varietycount.length == 0)
                                    ? SizedBox.shrink()
                                    : FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          '${varietycount.length} Varieties',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        )),
                                SizedBox(height: 7),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: InkWell(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[100],
                          ),
                          padding: EdgeInsets.all(5),
                          child: (widget.product?.favourite ?? false)
                              ? Icon(Icons.favorite,
                                  color: Colors.red, size: 27)
                              : Icon(Icons.favorite_border, size: 27),
                        ),
                        onTap: () {
                          setState(() {
                            widget.product.toggleFavoriteStatus();
                            Provider.of<ProductData>(context, listen: false)
                                .toggleFavoriteStatus(widget.product);
                          });
                        },
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//       Positioned(
//         bottom: 0,
//         right: 2,
//         child: FlatButton.icon(
//           color: Colors.grey[200],
//           // autofocus: true, focusColor: Colors.amber,
//           // splashColor: Colors.blueAccent,
//           label: Text('Varieties',
//               style: TextStyle(
//                   fontSize: 12,
//                   color: !isexpand ? Colors.black : Colors.blue)),
//           icon: Icon(
//               !isexpand ? Icons.expand_more : Icons.expand_less,
//               size: 12,
//               color: !isexpand ? Colors.black : Colors.blue),
//           onPressed: () {
//             isexpand = !isexpand;
//             setState(() {});
//           },
//         ),
//       )
// isexpand
//     ? Container(child: varietytable(), width: double.infinity)
//     : SizedBox.shrink(),

// (product.description == null || product.description == '')
//     ? SizedBox.shrink()
//     : Text(
//         'Description:  ${product.description}',
//         maxLines: 2,
//         softWrap: true,
//         overflow: TextOverflow.fade,
//       )
// (product.brand == null || product.brand == '')
//     ? (product.description == null || product.description == '')
//         ?
//         SizedBox.shrink()
//         : Text(
//             product.description,
//             maxLines: 1,
//             softWrap: true,
//             overflow: TextOverflow.fade,
//           )
//     : Text('Brand: ${product.brand}'),

// onSortnameColum(
//     int columnIndex, bool ascending, List<VarietyProductM> list) {
//   if (columnIndex == _sortColumnIndex) {
//     _sortAsc = _sortnameAsc = ascending;
//   } else {
//     _sortColumnIndex = columnIndex;
//     _sortAsc = _sortnameAsc;
//   }
//   list.sort((a, b) => _sortAsc
//       ? b.varityname.compareTo(a.varityname)
//       : a.varityname.compareTo(b.varityname));
//   setState(() {});
// }

// onSortpriceColum(
//     int columnIndex, bool ascending, List<VarietyProductM> list) {
//   if (columnIndex == _sortColumnIndex) {
//     _sortAsc = _sortpriceAsc = ascending;
//   } else {
//     _sortColumnIndex = columnIndex;
//     _sortAsc = _sortpriceAsc;
//   }
//   list.sort((a, b) =>
//       _sortAsc ? b.price.compareTo(a.price) : a.price.compareTo(b.price));
//   setState(() {});
// }

// onSortwspColum(
//     int columnIndex, bool ascending, List<VarietyProductM> list) {
//   if (columnIndex == _sortColumnIndex) {
//     _sortAsc = _sortwspAsc = ascending;
//   } else {
//     _sortColumnIndex = columnIndex;
//     _sortAsc = _sortwspAsc;
//   }
//   list.sort((a, b) =>
//       _sortAsc ? b.wsp.compareTo(a.price) : a.wsp.compareTo(b.price));
//   setState(() {});
// }

// List<DataRow> varietydatarow(List<VarietyProductM> varietylist) {
//   List<DataRow> rowlist = [];
//   for (VarietyProductM i in varietylist) {
//     rowlist.add(DataRow(selected: selectedvariety.contains(i), cells: [
//       DataCell(Text(i.varityname)),
//       DataCell(Text(i.price.toString())),
//       DataCell(Text(i.wsp.toString()))
//     ]));
//   }
//   return rowlist;
// }

// Widget varietytable() {
//   return varietylist.isEmpty
//       ? Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(8),
//           child: Text(
//             'No Variety Available',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 15,
//             ),
//             textAlign: TextAlign.center,
//           ),
//         )
//       : Column(
//           children: <Widget>[
//             Container(
//               padding: EdgeInsets.all(0),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   headingRowHeight: 50,
//                   columnSpacing: 40,
//                   dataRowHeight: 40,
//                   sortAscending: _sortAsc,
//                   sortColumnIndex: _sortColumnIndex,
//                   columns: [
//                     DataColumn(
//                         label: Text('Variety Name'),
//                         numeric: false,
//                         onSort: (columnIndex, ascending) {
//                           onSortnameColum(
//                               columnIndex, ascending, varietylist);
//                         }),
//                     DataColumn(
//                         label: Text('Variety Price'),
//                         numeric: true,
//                         onSort: (columnIndex, ascending) {
//                           onSortpriceColum(
//                               columnIndex, ascending, varietylist);
//                         }),
//                     DataColumn(
//                         label: Text('WSP'),
//                         numeric: true,
//                         onSort: (columnIndex, ascending) {
//                           onSortwspColum(
//                               columnIndex, ascending, varietylist);
//                         })
//                   ],
//                   rows: varietydatarow(varietylist),
//                 ),
//               ),
//             ),
//           ],
//         );
// }
