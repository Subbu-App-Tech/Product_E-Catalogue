import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Provider/ProductDataP.dart';
import '../../Models/ProductModel.dart';
import '../../Models/CategoryModel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:path_provider/path_provider.dart' as path;
import '../../Provider/CategoryDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../../Provider/VarietyDataP.dart';
import '../PdfTools.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import '../../Auth/ViewAdtoDownload.dart';
import '../../Models/SecureStorage.dart';
import 'package:firebase_admob/firebase_admob.dart';

class PDFListviewone extends StatefulWidget {
  static const routeName = '/PDFListviewone';
  const PDFListviewone({Key key}) : super(key: key);

  @override
  _PDFListviewoneState createState() => _PDFListviewoneState();
}

class _PDFListviewoneState extends State<PDFListviewone> {
  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-9568938816087708~5406343573');
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    childDirected: true,
    nonPersonalizedAds: true,
    // testDevices: ['70986832EA2D276F6277A5461962A4EC'],
  );
  InterstitialAd _interstitialAd;
  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: 'ca-app-pub-9568938816087708/7976666598',
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event $event");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    PdfImage image;
    Uint8List list;
    String filepath;
    Pdftools pdftool = Pdftools();
    List<CategoryModel> category = Provider.of<CategoryData>(context).items;
    List<ProcuctbasedModel> pbitems = [];
    Function findvardata = Provider.of<VarietyData>(context).findbyid;
    List<Brandcount> uqbrand = Provider.of<ProductData>(context).uqbrand();
    PDFDocument _pdfdoc;
    List frowd = ModalRoute.of(context).settings.arguments as List;
    Function findvarcount = Provider.of<VarietyData>(context).findvarietycount;
    String input = frowd[0];
    String sortby = frowd[1];
    bool ispaid = frowd[2];

    List<ProductModel> pm;
    if (input == 'brand') {
      for (Brandcount i in uqbrand) {
        pm = Provider.of<ProductData>(context).productlistbybrandname(i.name);
        pbitems.add(ProcuctbasedModel(
            basedon: i.name,
            productlist: pdftool.sortedlist(
                list: pm, functofindvarietycount: findvarcount, type: sortby)));
      }
    } else if (input == 'cat') {
      for (CategoryModel i in category) {
        pm = Provider.of<ProductData>(context).productlistbycatid(i.id);
        pbitems.add(ProcuctbasedModel(
            basedon: i.name,
            productlist: pdftool.sortedlist(
                list: pm, functofindvarietycount: findvarcount, type: sortby)));
      }
    } else if (input == 'all') {
      List<ProductModel> pm = Provider.of<ProductData>(context).items;
      pbitems.add(ProcuctbasedModel(
          basedon: 'All Product',
          productlist: pdftool.sortedlist(
              list: pm, functofindvarietycount: findvarcount, type: sortby)));
    }
    SecureStorage storage = SecureStorage();
    String currency;
    String contactno;
    String companyname;

    writeOnPdf() async {
      currency = await storage.getcurrency();
      contactno = await storage.getcontactno();
      companyname = await storage.getcompanyname();
      ByteData bytes = await rootBundle.load('assets/productc.png');
      Uint8List logo = bytes.buffer.asUint8List();
      PdfImage logoimage = PdfImage.file(
        pdf.document,
        bytes: logo,
      );

      Future<pw.Widget> _list(ProductModel productdata) async {
        if (pdftool.checkimagepath(productdata?.imagepathlist?.cast<String>()?? [])) {
          list = await new File(
                  '${pdftool.validimagepath(productdata?.imagepathlist?.cast<String>()?? [])[0]}')
              .readAsBytes();
          image = PdfImage.file(
            pdf.document,
            bytes: list,
          );
        } else {
          ByteData bytes = await rootBundle.load('assets/NoImage.png');
          list = bytes.buffer.asUint8List();
        }
        image = PdfImage.file(
          pdf.document,
          bytes: list,
        );

        return pw.Container(
            width: 575,
            padding: pw.EdgeInsets.all(2.5),
            foregroundDecoration: pw.BoxDecoration(
                borderRadius: 2,
                border: pw.BoxBorder(
                    bottom: true,
                    right: true,
                    left: true,
                    top: true,
                    width: 1)),
            child: pw.Row(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(2.5),
                    width: 140,
                    child: pw.Image(image, fit: pw.BoxFit.contain),
                  ),
                  pw.SizedBox(width: 5),
                  pw.Container(
                      width: 425,
                      child: pw.Column(
                          mainAxisSize: pw.MainAxisSize.min,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(
                              color: PdfColors.blue,
                              width: 425,
                              child: pw.Text('  ${productdata.name}',
                                  style: pw.TextStyle(
                                      fontSize: 20,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.white)),
                            ), //name
                            pw.SizedBox(height: 5),
                            pw.Container(
                              // width: 390,
                              child: pw.Row(
                                  mainAxisSize: pw.MainAxisSize.min,
                                  mainAxisAlignment: pw.MainAxisAlignment.start,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.start,
                                  children: [
                                    pw.Container(
                                        child: pw.Column(
                                            mainAxisSize: pw.MainAxisSize.min,
                                            mainAxisAlignment:
                                                pw.MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                pw.CrossAxisAlignment.start,
                                            children: <pw.Widget>[
                                          pw.SizedBox(height: 1),
                                          (productdata.brand == null ||
                                                  productdata.brand == '')
                                              ? pw.SizedBox(width: 0.5)
                                              : pw.Text(
                                                  'Brand:  ${productdata.brand}',
                                                  style: pw.TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          pw.FontWeight.bold),
                                                  textAlign: pw.TextAlign.left),
                                          pw.SizedBox(height: 3),
                                          (productdata.description.isEmpty)
                                              ? pw.SizedBox.shrink()
                                              : pw.Container(
                                                  alignment:
                                                      pw.Alignment.topLeft,
                                                  child: pw.Text(
                                                      'Product Description',
                                                      style: pw.TextStyle(
                                                          fontSize: 12))),
                                          (productdata.description.isEmpty)
                                              ? pw.SizedBox.shrink()
                                              : pw.Container(
                                                  // color: PdfColors.grey200,
                                                  width: 200,
                                                  alignment:
                                                      pw.Alignment.topLeft,
                                                  child: pw.Paragraph(
                                                      text:
                                                          '''${productdata.description}''',
                                                      style: pw.TextStyle(
                                                        fontSize: 10,
                                                      ),
                                                      textAlign: pw
                                                          .TextAlign.justify)),
                                        ])),
                                    (findvardata(productdata.id).length == 0)
                                        ? pw.SizedBox(width: 0.5)
                                        : pw.Container(
                                            padding: pw.EdgeInsets.fromLTRB(
                                                5, 2, 5, 2),
                                            alignment: pw.Alignment.topCenter,
                                            child: pdftool.varietytable(
                                                productdata.id,
                                                findvardata,
                                                currency,
                                                150,
                                                60,
                                                37)),
                                  ]),
                            )
                          ])),
                ]));
      }

      for (ProcuctbasedModel i in pbitems) {
        List<pw.Widget> _listview = [];
        for (ProductModel j in i.productlist) {
          _listview.add(await _list(j));
        }
        pdf.addPage(
          pw.MultiPage(
              pageTheme: await pdftool.pagetheam(5, ispaid),
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              maxPages: 200,
              header: (pw.Context ctx) {
                return pdftool.buildHeader(i.basedon, logoimage);
              },
              footer: (pw.Context ctx) {
                return pdftool.buildFooter(
                    context: ctx,
                    contactno: contactno,
                    companyname: companyname);
              },
              build: (context) => [
                    pw.Wrap(
                        children: _listview,
                        spacing: 5,
                        alignment: pw.WrapAlignment.start,
                        crossAxisAlignment: pw.WrapCrossAlignment.center,
                        runAlignment: pw.WrapAlignment.start,
                        runSpacing: 7)
                  ]),
        );
      }
    }

    Future savePdf() async {
      // await _interstitialAd?.dispose();
      // _interstitialAd = createInterstitialAd();
      // await _interstitialAd.load();
      // await _interstitialAd?.show();
      // await writeOnPdf();
      // Directory documentDirectory = await getTemporaryDirectory();
      // String documentPath = documentDirectory.path;
      // filepath = "$documentPath/ProductCatalogue6.pdf";
      // File file = File(filepath);
      // await file.writeAsBytes(pdf.save(), flush: true, mode: FileMode.write);
      // _pdfdoc = await PDFDocument.fromFile(file);
      await _interstitialAd?.dispose();
      _interstitialAd = createInterstitialAd();
      await _interstitialAd.load();
      await _interstitialAd?.show();
      await writeOnPdf();
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      filepath = "$documentPath/ProductCatalogue4.pdf";
      File file = File(filepath);
      file.writeAsBytesSync(pdf.save());
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
                      _interstitialAd?.dispose();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => ViewAdToDownload(
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

// class ProcuctbasedModel {
//   String basedon;
//   List<ProductModel> productlist;
//   ProcuctbasedModel({this.basedon, this.productlist});
// }
