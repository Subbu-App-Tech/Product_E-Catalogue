import 'package:flutter/material.dart';
import 'package:productcatalogue/Screens/Form/image_handle.dart';
import 'package:productcatalogue/main.dart';
import '../Screens/Form/product_form.dart';
import '../Provider/ProductDataP.dart';
import 'dart:io';
import '../Widgets/Group/carousel_pro/carousel_pro.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import '../Pdf/PdfTools.dart';
import 'dart:typed_data';

class ProductDetailsW extends StatefulWidget {
  final Product product;
  ProductDetailsW(this.product);

  @override
  _ProductDetailsWState createState() => _ProductDetailsWState();
}

class _ProductDetailsWState extends State<ProductDetailsW> {
  List<String> categorylist = [];
  bool _sortAsc = false;
  late List<VarietyProductM> selectedvariety;
  List<VarietyProductM> varietylist = [];
  int? _sortColumnIndex;
  bool _sortnameAsc = false;
  bool _sortpriceAsc = false;
  bool _sortwspAsc = false;
  String? currency;
  String? text;

  @override
  void initState() {
    _sortAsc = false;
    selectedvariety = [];
    _sortColumnIndex = 0;
    _sortpriceAsc = false;
    _sortnameAsc = false;
    _sortwspAsc = false;
    currencyset();
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    varietylist = widget.product.varieties;
    categorylist = widget.product.categories;
    currency = await storage.getcurrency();
    super.didChangeDependencies();
  }

  void currencyset() async => currency = await storage.getcurrency();
  List<FileImage>? images = [];
  Widget imageWid() {
    return Carousel(
        images: images,
        dotSize: 4.0,
        dotSpacing: 15.0,
        dotColor: Colors.white,
        indicatorBgPadding: 5.0,
        dotBgColor: Colors.black12.withOpacity(0.1),
        borderRadius: true,
        boxFit: BoxFit.contain);
  }

  Widget imageDetails() {
    images = haldler.imagefilelist(widget.product.imagepathlist);
    return InkWell(
      child: Hero(tag: '${widget.product.id}', child: imageWid()),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ImageFullView(
                    images: images ?? [], tag: '${widget.product.id}')));
      },
    );
  }

  List<Widget> catlist(List<String> list) {
    return list
        .map((e) => Container(
            child: Text(e),
            padding: EdgeInsets.all(7),
            color: Colors.lightBlue[300]))
        .toList();
  }

  String get vatText => widget.product.varieties
      .map((e) => '${e.name} - ${e.price} - ${e.wsp}')
      .join('\n');
  void updateTxt() {
    if (widget.product.description == null ||
        widget.product.description!.trim() == '') {
      text = '''
${widget.product.name}

Varieties:
  $vatText
            
Created & Shared By Product E-Catalogue App''';
    } else {
      text = '''
${widget.product.name}
Description:
  ${widget.product.description}
Varieties:
  $vatText
            
Created with Product E-Catalogue App''';
    }
  }

  ImageHandler haldler = ImageHandler();
  @override
  Widget build(BuildContext context) {
    Pdftools pdftool = Pdftools();
    final varPriceRange = widget.product.minMaxPrice;
    updateTxt();
    onSortnameColum(
        int columnIndex, bool ascending, List<VarietyProductM> list) {
      if (columnIndex == _sortColumnIndex) {
        _sortAsc = _sortnameAsc = ascending;
      } else {
        _sortColumnIndex = columnIndex;
        _sortAsc = _sortnameAsc;
      }
      list.sort((a, b) =>
          _sortAsc ? b.name.compareTo(a.name) : a.name.compareTo(b.name));
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
          DataCell(Text(i.name)),
          DataCell(Text((i.price).toString())),
          DataCell(Text((i.wsp).toString()))
        ]));
      }
      return rowlist;
    }

    Widget _deleteconfirmation(BuildContext context) {
      return AlertDialog(
        title: Text('Do You Want to Delete this Product ?',
            textAlign: TextAlign.center),
        content: Text('Note: You can\'t redo it'),
        actions: [
          ElevatedButton(
            child: Text('Delete Data'),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              Provider.of<ProductData>(context, listen: false)
                  .deleteproduct(widget.product.id);
              Navigator.pop(context);
            },
          ),
          ElevatedButton(
              child: Text('Back'), onPressed: () => Navigator.pop(context))
        ],
      );
    }

    void _shareImageAndText() async {
      try {
        Uint8List bytes;
        if (pdftool.checkimagepath(widget.product.imagepathlist)) {
          bytes = await File(
                  pdftool.validimagepath(widget.product.imagepathlist).first)
              .readAsBytes();
          String ext = pdftool
              .validimagepath(widget.product.imagepathlist.cast<String>())[0]
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
        BotToast.showText(text: 'Error Occurs :: $e');
      }
    }

    currency = currency ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(widget.product.name)),
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
                      child:
                          haldler.checkimagepath(widget.product.imagepathlist)
                              ? imageDetails()
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
                    child: StatefulBuilder(builder: (context, setState) {
                      return RawMaterialButton(
                          splashColor: Colors.red,
                          elevation: 7,
                          shape: CircleBorder(),
                          child: (widget.product.favourite)
                              ? Icon(Icons.favorite,
                                  color: Colors.red, size: 30)
                              : Icon(Icons.favorite_border, size: 30),
                          fillColor: Colors.white,
                          padding: EdgeInsets.all(8),
                          onPressed: () {
                            Provider.of<ProductData>(context, listen: false)
                                .toggleFavoriteStatus(widget.product);
                            setState(() {});
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
              child: Text(widget.product.name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  textAlign: TextAlign.center),
            ),
            SizedBox(height: 4),
            (varPriceRange.first == 0 && varPriceRange.last == 0)
                ? Text('0',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
                : (varPriceRange[0] == varPriceRange[1])
                    ? Text('$currency ${varPriceRange[0].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25))
                    : Text(
                        '$currency ${varPriceRange[0].toStringAsFixed(2)} - '
                        '${varPriceRange[1].toStringAsFixed(2)}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 25)),
            Divider(),
            if (widget.product.brand != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text('Brand: ${widget.product.brand ?? ''}',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ),
            Divider(),
            (categorylist.isEmpty)
                ? SizedBox(height: 0.1)
                : Container(
                    padding: EdgeInsets.all(8),
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Product Category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                          textAlign: TextAlign.left,
                        ),
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(border: Border.all()),
                          padding: EdgeInsets.all(3),
                          child: Wrap(
                              runSpacing: 3,
                              children: catlist(categorylist),
                              spacing: 3),
                        ),
                      ],
                    ),
                  ),
            varietylist.isEmpty
                ? Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(8),
                    child: Text('No Variety Available',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.center),
                  )
                : Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(8),
                        child: Text('Varity of Product',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                            textAlign: TextAlign.left),
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
                ? SizedBox(height: 0.1)
                : (widget.product.description!.isEmpty)
                    ? SizedBox(height: 0.1)
                    : Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            child: Text('Product Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                                textAlign: TextAlign.left),
                          ),
                          Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(15),
                              child: Text(widget.product.description!,
                                  textAlign: TextAlign.left))
                        ],
                      ),
            SizedBox(height: 50),
            // adwidget,
            SizedBox(height: 50),
            Container(
                child: Text('Rank: ${widget.product.rank}',
                    style: TextStyle(fontSize: 14))),
            SizedBox(height: 3),
            appSetting.isViewMode
                ? SizedBox()
                // ignore: deprecated_member_use
                : RaisedButton.icon(
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
      floatingActionButton: appSetting.isViewMode
          ? FloatingActionButton.extended(
              heroTag: null,
              backgroundColor: Colors.green,
              label: Text('Share'),
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () => _shareImageAndText(),
            )
          : Container(
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
                    onPressed: () => _shareImageAndText(),
                  ),
                ],
              ),
            ),
    );
  }
}

class ImageFullView extends StatelessWidget {
  final List<FileImage> images;
  final String tag;
  const ImageFullView({Key? key, required this.tag, required this.images})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
            child: Hero(
                tag: tag,
                child: Carousel(
                    images: images,
                    dotSize: 4.0,
                    dotSpacing: 15.0,
                    dotColor: Colors.white,
                    indicatorBgPadding: 5.0,
                    dotBgColor: Colors.black12.withOpacity(0.1),
                    borderRadius: true,
                    boxFit: BoxFit.contain)),
            onTap: () => Navigator.pop(context)));
  }
}
