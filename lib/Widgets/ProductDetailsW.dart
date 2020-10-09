import 'package:flutter/material.dart';
import 'package:productcatalogue/Models/VarietyProductModel.dart';
import 'package:provider/provider.dart';
import '../Screens/UserAEFrom.dart';
import '../Models/ProductModel.dart';
import '../Provider/CategoryDataP.dart';
import '../Provider/VarietyDataP.dart';
import '../Provider/ProductDataP.dart';
import 'dart:io';
import 'package:carousel_pro/carousel_pro.dart';
import '../main.dart';
import '../Models/SecureStorage.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../Pdf/PdfTools.dart';
import 'dart:typed_data';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:async';
import 'package:flutter_native_admob/flutter_native_admob.dart' as ad;
import 'package:flutter_native_admob/native_admob_controller.dart';

class ProductDetailsW extends StatefulWidget {
  final ProductModel product;
  ProductDetailsW(this.product);

  @override
  _ProductDetailsWState createState() => _ProductDetailsWState();
}

class _ProductDetailsWState extends State<ProductDetailsW> {
  List<String> categorylist = [];
  bool _sortAsc;
  List<VarietyProductM> selectedvariety;
  List<VarietyProductM> varietylist = [];
  int _sortColumnIndex;
  bool _sortnameAsc;
  bool _sortpriceAsc;
  bool _sortwspAsc;
  SecureStorage storage = SecureStorage();
  String currency;
  String varietydetails;
  String text;

  @override
  void initState() {
    _sortAsc = false;
    varietydetails = '';
    selectedvariety = [];
    _sortColumnIndex = 0;
    _sortpriceAsc = false;
    _sortnameAsc = false;
    _sortwspAsc = false;
     currencyset();
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    _nativeAdController.setAdUnitID(_adUnitID, numberAds: 2);
    super.initState();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
        });
        break;
      case AdLoadState.loadCompleted:
        setState(() {
          _height = 125;
        });
        break;
      default:
        break;
    }
  }

  @override
  void didChangeDependencies() async {
    if (widget.product.categorylist == null) {
      categorylist = [];
    } else {
      categorylist = Provider.of<CategoryData>(context)
          .findcategorylist(widget.product.categorylist);
    }
    varietylist =
        Provider.of<VarietyData>(context).findbyid(widget.product?.id);
    varietydetails =
        Provider.of<VarietyData>(context).vartext(widget.product?.id);
    currency = await storage.getcurrency();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  StreamSubscription _subscription;

  Widget get adwidget {
    return Card(
      child: Container(
        height: _height,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ad.NativeAdmob(
            adUnitID: _adUnitID,
            error: Text('Error'),
            numberAds: 2,
            type: ad.NativeAdmobType.full,
            controller: _nativeAdController,
            options: NativeAdmobOptions(
                priceTextStyle:
                    NativeTextStyle(fontSize: 15, color: Colors.red),
                bodyTextStyle:
                    NativeTextStyle(fontSize: 14, color: Colors.black)),
            loading: Text('Loading')),
      ),
    );
  }

  void currencyset() async {
    currency = await storage.getcurrency();
  }

  @override
  Widget build(BuildContext context) {
    Pdftools pdftool = Pdftools();
    final varietypricerange =
        Provider.of<VarietyData>(context).minmaxvalue(widget.product.id);

    List<String> validimagepath(List<String> pathlist) {
      List<String> valid = [];
      for (String i in pathlist) {
        if (File(i).existsSync()) {
          valid.add(i);
        }
      }
      return valid;
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

    List<Widget> catlist(List list) {
      List<Widget> widlist = [];
      for (String i in list) {
        widlist.add(Container(
          child: Text(i),
          padding: EdgeInsets.all(7),
          color: Colors.lightBlue[300],
        ));
      }
      return widlist;
    }

    onSortnameColum(
        int columnIndex, bool ascending, List<VarietyProductM> list) {
      if (columnIndex == _sortColumnIndex) {
        _sortAsc = _sortnameAsc = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAsc = _sortnameAsc;
      }
      list.sort((a, b) => _sortAsc
          ? b.varityname.compareTo(a.varityname)
          : a.varityname.compareTo(b.varityname));
      setState(() {});
    }

    onSortpriceColum(
        int columnIndex, bool ascending, List<VarietyProductM> list) {
      if (columnIndex == _sortColumnIndex) {
        _sortAsc = _sortpriceAsc = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAsc = _sortpriceAsc;
      }
      list.sort((a, b) =>
          _sortAsc ? b.price.compareTo(a.price) : a.price.compareTo(b.price));
      setState(() {});
    }

    onSortwspColum(
        int columnIndex, bool ascending, List<VarietyProductM> list) {
      if (columnIndex == _sortColumnIndex) {
        _sortAsc = _sortwspAsc = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAsc = _sortwspAsc;
      }
      list.sort((a, b) =>
          _sortAsc ? b.wsp.compareTo(a.price) : a.wsp.compareTo(b.price));
      setState(() {});
    }

    List<DataRow> varietydatarow(List<VarietyProductM> varietylist) {
      List<DataRow> rowlist = [];
      for (VarietyProductM i in varietylist) {
        rowlist.add(DataRow(selected: selectedvariety.contains(i), cells: [
          DataCell(Text(i.varityname)),
          DataCell(Text(i.price.toString())),
          DataCell(Text(i.wsp.toString()))
        ]));
      }
      return rowlist;
    }

    Widget _deleteconfirmation(BuildContext context) {
      return AlertDialog(
        title: Text(
          'Do You Want to Delete this Product ?',
          textAlign: TextAlign.center,
        ),
        content: Text('Note: You can\'t redo it'),
        actions: [
          RaisedButton(
            child: Text('Delete Data', style: TextStyle(color: Colors.white)),
            color: Colors.red,
            onPressed: () {
              Navigator.pop(context);
              Provider.of<ProductData>(context, listen: false)
                  .deleteproduct(widget.product.id);
              Provider.of<VarietyData>(context, listen: false)
                  .delete(widget.product.id);
              Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => ProductCatalogue()))
                  .whenComplete(() => setState(() {}));
              // Navigator.popUntil(
              //     context, ModalRoute.withName(Tabscreenwithdata.routeName));
            },
          ),
          RaisedButton(
            child: Text('Back'),
            color: Colors.blueAccent,
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    }

    if (widget.product.description == null ||
        widget.product.description.trim() == '') {
      text = '''
${widget.product.name}

Varieties:
$varietydetails
            
Created & Shared By Product E-Catalogue App''';
    } else {
      text = '''
${widget.product.name}
Description:
  ${widget.product.description}
Varieties:
  $varietydetails
            
Created with Product E-Catalogue App''';
    }

    void _shareImageAndText() async {
      try {
        Uint8List bytes;
        if (pdftool.checkimagepath(widget.product.imagepathlist)) {
          bytes = await File(
                  '${pdftool.validimagepath(widget.product.imagepathlist)[0]}')
              .readAsBytes();
          String ext = pdftool
              .validimagepath(widget.product.imagepathlist)[0]
              .split('.')
              .last;
          await WcFlutterShare.share(
              sharePopupTitle: 'share',
              subject: '${widget.product.name}',
              text: text,
              fileName: '${widget.product.name}.png',
              mimeType: 'image/$ext',
              bytesOfFile: bytes.buffer.asUint8List());
        } else {
          await WcFlutterShare.share(
              sharePopupTitle: 'share',
              subject: '${widget.product.name}',
              text: text,
              mimeType: 'text/plain');
        }
      } catch (e) {
        print('error: $e');
      }
    }

    currency = currency ?? '';
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.black,
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 250,
                      width: double.infinity,
                      padding: EdgeInsets.all(8),
                      child: checkimagepath(widget.product.imagepathlist)
                          ? Carousel(
                              images:
                                  imagefilelist(widget.product.imagepathlist),
                              dotSize: 4.0,
                              dotSpacing: 15.0,
                              dotColor: Colors.white,
                              indicatorBgPadding: 5.0,
                              dotBgColor: Colors.black26,
                              borderRadius: true,
                              boxFit: BoxFit.contain,
                            )
                          : Center(
                              child: Container(
                              height: 240,
                              width: 240,
                              color: Colors.grey[400],
                              alignment: Alignment.center,
                              child: Text(
                                'No Image',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ))),
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: RawMaterialButton(
                        splashColor: Colors.red,
                        elevation: 7,
                        shape: CircleBorder(),
                        child: widget.product.favourite
                            ? Icon(Icons.favorite, color: Colors.red, size: 30)
                            : Icon(Icons.favorite_border, size: 30),
                        fillColor: Colors.white,
                        padding: EdgeInsets.all(8),
                        onPressed: () {
                          setState(() {
                            widget.product.toggleFavoriteStatus();
                            Provider.of<ProductData>(context, listen: false)
                                .toggleFavoriteStatus(widget.product);
                          });
                        }),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              color: Colors.grey[300],
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
              child: Text(
                widget.product.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 4),
            (varietypricerange == null || varietypricerange.length == 0)
                ? Text(
                    '0',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                  )
                : (varietypricerange[0] == varietypricerange[1])
                    ? Text(
                        '$currency ${varietypricerange[0].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      )
                    : Text(
                        '$currency ${varietypricerange[0].toStringAsFixed(2)} - ${varietypricerange[1].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25),
                      ),
            Divider(),
            if (widget.product.brand != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  'Brand: ${widget.product.brand ?? ''}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
            Divider(),
            (categorylist.isEmpty)
                ? SizedBox(
                    height: 0.1,
                  )
                : Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Category',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(),
                          ),
                          padding: EdgeInsets.all(3),
                          child: Wrap(
                            runSpacing: 3,
                            children: catlist(categorylist),
                            spacing: 3,
                          ),
                        ),
                      ],
                    ),
                  ),
            varietylist.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text(
                      'No Variety Available',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Varity of Product',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowHeight: 50,
                            columnSpacing: 40,
                            dataRowHeight: 40,
                            sortAscending: _sortAsc,
                            sortColumnIndex: _sortColumnIndex,
                            columns: [
                              DataColumn(
                                  label: Text('Variety Name'),
                                  numeric: false,
                                  onSort: (columnIndex, ascending) {
                                    onSortnameColum(
                                        columnIndex, ascending, varietylist);
                                  }),
                              DataColumn(
                                  label: Text('Variety Price'),
                                  numeric: true,
                                  onSort: (columnIndex, ascending) {
                                    onSortpriceColum(
                                        columnIndex, ascending, varietylist);
                                  }),
                              DataColumn(
                                  label: Text('WSP'),
                                  numeric: true,
                                  onSort: (columnIndex, ascending) {
                                    onSortwspColum(
                                        columnIndex, ascending, varietylist);
                                  })
                            ],
                            rows: varietydatarow(varietylist),
                          ),
                        ),
                      ),
                    ],
                  ),
            Divider(),
            (widget.product.description == null)
                ? SizedBox(
                    height: 0.1,
                  )
                : (widget.product.description.isEmpty)
                    ? SizedBox(
                        height: 0.1,
                      )
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Text(
                              'Product Description',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              child: Text(
                                (widget.product.description),
                                textAlign: TextAlign.left,
                              ))
                        ],
                      ),
            SizedBox(height: 50),
            adwidget,
            SizedBox(height: 50),
            Container(
                child: Text('Rank: ${widget.product.rank}',
                    style: TextStyle(fontSize: 14))),
            SizedBox(height: 3),
            RaisedButton.icon(
              elevation: 3,
              padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
              color: Colors.red,
              icon: Icon(Icons.delete),
              label: Text(
                'Delete Product',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _deleteconfirmation(context),
                );
              },
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.all(7),
        width: double.infinity,
        child: Row(
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              label: Text('Edit'),
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.pushNamed(context, UserAEForm.routeName,
                    arguments: widget.product.id);
              },
            ),
            Spacer(flex: 1),
            FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: Colors.green,
              label: Text('Share'),
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () {
                _shareImageAndText();
              },
            ),
          ],
        ),
      ),
    );
  }
}
