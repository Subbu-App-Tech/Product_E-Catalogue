import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Provider/ProductDataP.dart';
import '../../Models/ProductModel.dart';
import '../../Models/CategoryModel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import '../../Provider/CategoryDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../../Provider/VarietyDataP.dart';
import '../PdfTools.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
// import '../../Auth/ViewAdtoDownload.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../Models/SecureStorage.dart';

class PDFGridViewPV extends StatefulWidget {
  static const routeName = '/PDFGridViewPV';
  const PDFGridViewPV({Key? key}) : super(key: key);

  @override
  _PDFGridViewPVState createState() => _PDFGridViewPVState();
}

class _PDFGridViewPVState extends State<PDFGridViewPV> {
  @override
  void initState() {
    Pdftools.createInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pdf = pw.Document();
    PdfImage image;
    Uint8List list;
    String filepath;
    Pdftools pdftool = Pdftools();
    SecureStorage storage = SecureStorage();
    String currency;
    late PDFDocument _pdfdoc;
    List<CategoryModel> category = Provider.of<CategoryData>(context).items;
    List<ProcuctbasedModel> pbitems = [];
    Function findvardata = Provider.of<VarietyData>(context).findbyid;
    Function findvarcount = Provider.of<VarietyData>(context).findvarietycount;
    List<Brandcount> uqbrand = Provider.of<ProductData>(context).uqbrand();
    List frowd = ModalRoute.of(context)!.settings.arguments as List;
    String input = frowd[0];
    String sortby = frowd[1];
    bool ispaid = frowd[2];
    List<ProductModel?> pm;
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
      List<ProductModel?> pm = Provider.of<ProductData>(context).items;
      pbitems.add(ProcuctbasedModel(
          basedon: 'All Product',
          productlist: pdftool.sortedlist(
              list: pm, functofindvarietycount: findvarcount, type: sortby)));
    } //pm, 'variety', findvarcount

    String contactno;
    String companyname;
    Future writeOnPdf() async {
      currency = await storage.getcurrency();
      contactno = await storage.getcontactno();
      companyname = await storage.getcompanyname();
      ByteData bytes = await rootBundle.load('assets/productc.png');
      Uint8List logo = bytes.buffer.asUint8List();
      PdfImage logoimage = PdfImage.file(pdf.document, bytes: logo);
      Future<pw.Widget> _list(ProductModel productdata) async {
        if (pdftool
            .checkimagepath(productdata.imagepathlist?.cast<String>() ?? [])) {
          list = await new File(
                  '${pdftool.validimagepath(productdata.imagepathlist?.cast<String>() ?? [])}')
              .readAsBytes();
          image = PdfImage.file(pdf.document, bytes: list);
        } else {
          ByteData bytes = await rootBundle.load('assets/NoImage.png');
          list = bytes.buffer.asUint8List();
        }
        image = PdfImage.file(pdf.document, bytes: list);

        return pw.Container(
            width: 285,
            padding: pw.EdgeInsets.all(2.5),
            foregroundDecoration: pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
              // border: pw.BoxBorder(
              //     bottom: true,
              //     right: true,
              //     left: true,
              //     top: true,
              //     width: 1)
            ),
            child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Container(
                      width: double.infinity,
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text('${productdata.name}',
                          textAlign: pw.TextAlign.center,
                          style: pw.TextStyle(
                              fontSize: 15,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.white)),
                      color: PdfColors.blueAccent),
                  pw.SizedBox(width: 3),
                  pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                    pw.Container(
                      width: 87,
                      padding: pw.EdgeInsets.all(3),
                      alignment: pw.Alignment.center,
                      child: pw.Image(pw.ImageProxy(image),
                          fit: pw.BoxFit.contain),
                    ),
                    pw.Container(
                        alignment: pw.Alignment.topCenter,
                        width: 188,
                        child: pw.Column(
                            mainAxisSize: pw.MainAxisSize.min,
                            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: <pw.Widget>[
                              (productdata.description == null ||
                                      productdata.description!.trim() == '')
                                  ? pw.SizedBox.shrink()
                                  : pw.Container(
                                      padding: pw.EdgeInsets.only(
                                          bottom: 2, top: 2, left: 2, right: 2),
                                      alignment: pw.Alignment.topLeft,
                                      child: pw.Paragraph(
                                          padding: pw.EdgeInsets.all(1),
                                          text:
                                              '''${productdata.description}''',
                                          style: pw.TextStyle(
                                            fontSize: 8,
                                          ),
                                          textAlign: pw.TextAlign.justify)),
                              (productdata.brand == null ||
                                      productdata.brand == '')
                                  ? pw.SizedBox.shrink()
                                  : pw.Container(
                                      padding: pw.EdgeInsets.all(2),
                                      color: PdfColors.grey200,
                                      alignment: pw.Alignment.centerLeft,
                                      child: pw.Text(
                                          'Brand :-  ${productdata.brand}',
                                          style: pw.TextStyle(
                                              fontSize: 10,
                                              fontWeight: pw.FontWeight.bold),
                                          textAlign: pw.TextAlign.center)),
                              pw.SizedBox(height: 1),
                              (findvardata(productdata.id).length == 0)
                                  ? pw.SizedBox.shrink()
                                  : pw.Container(
                                      alignment: pw.Alignment.center,
                                      child: pdftool.varietytable(
                                          productdata.id,
                                          findvardata,
                                          currency,
                                          115,
                                          55,
                                          35)),
                            ])),
                  ])
                ]));
      }

      for (ProcuctbasedModel i in pbitems) {
        List<pw.Widget> _listview = [];
        for (ProductModel? j in i.productlist!) {
          _listview.add(await _list(j!));
        }
        pdf.addPage(
          pw.MultiPage(
              pageTheme: await pdftool.pagetheam(3, ispaid),
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              maxPages: 200,
              header: (pw.Context ctx) {
                return pdftool.buildHeader(i.basedon!, logoimage);
              },
              footer: (pw.Context ctx) {
                return pdftool.buildFooter(
                    context: ctx,
                    contactno: contactno,
                    companyname: companyname);
              },
              build: (context) =>
                  [pw.Wrap(children: _listview, spacing: 5, runSpacing: 5)]),
        );
      }
    }

    Future savePdf() async {
      await writeOnPdf();
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      filepath = "$documentPath/ProductCatalogue4.pdf";
      File file = File(filepath);
      file.writeAsBytesSync(await pdf.save());
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder:  (ctx) => ViewAdToDownload(
                      //       filepath: filepath,
                      //       ispaid: ispaid),
                      //   ),
                      // );
                    },
                  )
                ],
              ),
              body: PDFViewer(
                  document: _pdfdoc,
                  showNavigation: true,
                  lazyLoad: true,
                  progressIndicator: CircularProgressIndicator()));
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
                SizedBox(height: 15),
                Text('''Your Catalogue is Preparing.
It will take a Time based on Product Data''', textAlign: TextAlign.center)
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
