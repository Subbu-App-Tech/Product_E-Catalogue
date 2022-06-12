import 'dart:io';
import 'package:flutter/material.dart';
import 'package:productcatalogue/UPI_Transaction.dart';
import '../../Provider/ProductDataP.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:typed_data';
import 'PdfTools.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:permission_handler/permission_handler.dart';

class PDFPage extends StatefulWidget {
  final Function(List<ProcuctbasedModel>,bool) getDataFunc;
  final bool ispaid;
  static const routeName = '/PDFListviewone';
  const PDFPage({Key? key, required this.getDataFunc, required this.ispaid}) : super(key: key);

  @override
  _PDFPageState createState() => _PDFPageState();
}

class _PDFPageState extends State<PDFPage> {
  @override
  void initState() {
    Pdftools.createInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String filepath = '';
    Pdftools pdftool = Pdftools();
    List<String> category = Provider.of<ProductData>(context).uqCategList;
    List<Count> uqbrand = Provider.of<ProductData>(context).uqBrand;
    List<ProcuctbasedModel> pbitems = [];
    late PDFDocument _pdfdoc;
    List frowd = ModalRoute.of(context)!.settings.arguments as List;
    String input = frowd[0];
    String sortby = frowd[1];
    bool ispaid = frowd[2];

    List<Product> pm;
    if (input == 'brand') {
      for (Count i in uqbrand) {
        pm = Provider.of<ProductData>(context).prodListByBrand(i.name);
        pbitems.add(ProcuctbasedModel(
            basedon: i.name,
            productlist: pdftool.sortedlist(list: pm, type: sortby)));
      }
    } else if (input == 'cat') {
      for (String i in category) {
        pm = Provider.of<ProductData>(context).prodListByCateg(i);
        pbitems.add(ProcuctbasedModel(
            basedon: i,
            productlist: pdftool.sortedlist(list: pm, type: sortby)));
      }
    } else if (input == 'all') {
      List<Product> pm = Provider.of<ProductData>(context).items;
      pbitems.add(ProcuctbasedModel(
          basedon: 'All Product',
          productlist: pdftool.sortedlist(list: pm, type: sortby)));
    }

    Future savePdf() async {
      if (await Permission.storage.isDenied) {
        PermissionStatus status = await Permission.storage.request();
        if (status.isDenied) {
          BotToast.showText(text: 'Permission Denied Cant able to create file');
          return;
        }
      }
      Uint8List list =
      await widget.getDataFunc(pbitems,widget.ispaid );

      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      filepath = "$documentPath/ProductCatalogue4.pdf";
      File file = File(filepath);
      file.writeAsBytesSync(list);
      _pdfdoc = await PDFDocument.fromFile(File(filepath));
    }

    return FutureBuilder(
      future: savePdf(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Product Catalogue'),
                actions: [
                  IconButton(
                    icon: Icon(Icons.print),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => Upitransactionpage(
                                  filepath: filepath, ispaid: ispaid)));
                    },
                  ),
                ],
              ),
              body: PDFViewer(document: _pdfdoc, showNavigation: true));
        } else {
          return Scaffold(
              body: Center(
                  child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                Text('''
Your Catalogue is Preparing.
It will tak a while if your product has many Images
''', textAlign: TextAlign.center)
              ],
            ),
          )));
        }
      },
    );
  }
}
