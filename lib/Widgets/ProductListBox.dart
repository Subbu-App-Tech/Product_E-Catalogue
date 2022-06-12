import 'package:flutter/material.dart';
import 'package:productcatalogue/Screens/Form/image_handle.dart';
import '../Screens/ProductDetails.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/Group/carousel_pro/carousel_pro.dart';

class ProductListBox extends StatefulWidget {
  final Product product;
  ProductListBox({required this.product});

  @override
  _ProductListBoxState createState() => _ProductListBoxState();
}

class _ProductListBoxState extends State<ProductListBox> {
  String currency = '';
  List<String> categorylist = [];
  List<VarietyProductM>? selectedvariety;
  List<VarietyProductM> varietylist = [];
  String? varietydetails;
  String? text;
  bool? isexpand;

  @override
  void initState() {
    isexpand = false;
    varietydetails = '';
    selectedvariety = [];
    currencyset();
    setState(() {});
    super.initState();
  }

  void currencyset() async {
    currency = await storage.getcurrency();
  }

  @override
  void didChangeDependencies() {
    imgHandler = ImageHandler();
    varietylist = widget.product.varieties;
    super.didChangeDependencies();
  }

  late ImageHandler imgHandler;
  @override
  Widget build(BuildContext context) {
    final varietyrange = widget.product.minMaxPrice;
    final varietycount = widget.product.varieties.length;

    return Material(
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) => ProductDetails(widget.product.id)));
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
                            child: imgHandler.checkimagepath(
                                    widget.product.imagepathlist)
                                ? Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    alignment: Alignment.center,
                                    height: 80,
                                    width: 80,
                                    child: Carousel(
                                        images: imgHandler.imagefilelist(widget
                                            .product.imagepathlist
                                            .cast<String>()),
                                        dotSize: 3,
                                        dotSpacing: 5,
                                        dotColor: Colors.white,
                                        indicatorBgPadding: 5.0,
                                        dotBgColor: Colors.black26,
                                        borderRadius: true,
                                        boxFit: BoxFit.contain))
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
                                    widget.product.name,
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
                                  child: (varietyrange.length == 0)
                                      ? Text('${currency.toUpperCase()} 0',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold))
                                      : (varietyrange[0] == varietyrange[1])
                                          ? Text(
                                              '${currency.toUpperCase()} ${varietyrange[0].toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.red,
                                                  fontWeight: FontWeight.bold))
                                          : Text(
                                              '${currency.toUpperCase()} ${varietyrange[0].toStringAsFixed(2)} - '
                                              '${varietyrange[1].toStringAsFixed(2)}',
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
                                (varietycount == 0)
                                    ? SizedBox.shrink()
                                    : FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          '$varietycount Varieties',
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
                          child: (widget.product.favourite)
                              ? Icon(Icons.favorite,
                                  color: Colors.red, size: 27)
                              : Icon(Icons.favorite_border, size: 27),
                        ),
                        onTap: () {
                          widget.product.toggleFavoriteStatus();
                          Provider.of<ProductData>(context, listen: false)
                              .toggleFavoriteStatus(widget.product);
                          // setState(() {
                          // });
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
