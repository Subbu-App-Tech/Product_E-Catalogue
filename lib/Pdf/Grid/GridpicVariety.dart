import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import '../../Provider/ProductDataP.dart';
import '../../Models/ProductModel.dart';
import '../../Models/CategoryModel.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';
import '../../Provider/CategoryDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../../Provider/VarietyDataP.dart';
import '../PdfTools.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import '../../Models/SecureStorage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class PDFGridpicVarietyVertical extends StatefulWidget {
  static const routeName = '/PDFGridpicVarietyVertical';
  const PDFGridpicVarietyVertical({Key? key}) : super(key: key);

  @override
  _PDFGridpicVarietyVerticalState createState() =>
      _PDFGridpicVarietyVerticalState();
}

class _PDFGridpicVarietyVerticalState extends State<PDFGridpicVarietyVertical> {

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
    PDFDocument? pdfdoc;
    Pdftools pdftool = Pdftools();
    List<CategoryModel> category = Provider.of<CategoryData>(context).items;
    List<ProcuctbasedModel> pbitems = [];
    Function varietyrangefunc = Provider.of<VarietyData>(context).minmaxvalue;
    Function findvardata = Provider.of<VarietyData>(context).findbyid;
    List<Brandcount> uqbrand = Provider.of<ProductData>(context).uqbrand();
    SecureStorage storage = SecureStorage();
    String currency;
    List frowd = ModalRoute.of(context)!.settings.arguments as List;
    Function findvarcount = Provider.of<VarietyData>(context).findvarietycount;
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
    }
    String contactno;
    String companyname;
    Future writeOnPdf() async {
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
        final List<double>? varietyrange = varietyrangefunc(productdata.id);
        String? priceA;
        String? priceB;
        if (varietyrange == null || varietyrange.length == 0) {
          priceA = '0';
          priceB = null;
        } else if (varietyrange[0] == varietyrange[1]) {
          priceA = varietyrange[0].toString();
          priceB = null;
        } else if (varietyrange[0] != varietyrange[1]) {
          priceA = varietyrange[0].toString();
          priceB = varietyrange[1].toString();
        }
        if (pdftool
            .checkimagepath(productdata.imagepathlist?.cast<String>() ?? [])) {
          list = await new File(
                  '${pdftool.validimagepath(productdata.imagepathlist?.cast<String>() ?? [])[0]}')
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
          // color: PdfColors.grey100,
          padding: pw.EdgeInsets.all(2),
          width: 190,
          child: pw.Column(
              mainAxisSize: pw.MainAxisSize.max,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: <pw.Widget>[
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
                pw.Container(
                  width: 190,
                  alignment: pw.Alignment.center,
                  padding: pw.EdgeInsets.all(3),
                  child: pw.Image(pw.ImageProxy(image),
                      fit: pw.BoxFit.contain, height: 100),
                ),
                pw.SizedBox(height: 4),
                pw.Text((priceB == null) ? 'Price' : 'Price Range',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: pw.TextAlign.left),
                (priceB == null)
                    ? pw.FittedBox(
                        alignment: pw.Alignment.centerRight,
                        fit: pw.BoxFit.contain,
                        child: pw.Text('  $currency  $priceA',
                            style: pw.TextStyle(
                                fontSize: 14,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red400),
                            textAlign: pw.TextAlign.right,
                            maxLines: 1))
                    : pw.FittedBox(
                        alignment: pw.Alignment.centerRight,
                        fit: pw.BoxFit.contain,
                        child: pw.Text(
                          '  $currency  $priceA - $priceB',
                          style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.red400),
                          textAlign: pw.TextAlign.right,
                          maxLines: 1,
                        )),
                (productdata.description == null ||
                        productdata.description!.trim() == '')
                    ? pw.SizedBox.shrink()
                    : pw.Container(
                        padding: pw.EdgeInsets.only(
                            bottom: 2, top: 2, left: 2, right: 2),
                        alignment: pw.Alignment.topLeft,
                        child: pw.Paragraph(
                            padding: pw.EdgeInsets.all(1),
                            text: '''${productdata.description}''',
                            style: pw.TextStyle(
                              fontSize: 8,
                            ),
                            textAlign: pw.TextAlign.justify)),
                (productdata.brand == null || productdata.brand == '')
                    ? pw.SizedBox.shrink()
                    : pw.Container(
                        padding: pw.EdgeInsets.all(2),
                        color: PdfColors.grey300,
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text('Brand :-  ${productdata.brand}',
                            style: pw.TextStyle(
                                fontSize: 10, fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center)),
                pw.SizedBox(width: 2),
                (findvardata(productdata.id).length == 0)
                    ? pw.SizedBox(width: 0.5)
                    : pw.Container(
                        width: double.infinity,
                        child: pdftool.varietytable(productdata.id, findvardata,
                            currency, 110, 65, 27)),
                pw.SizedBox(width: 2),
              ]),
        );
      }

      for (ProcuctbasedModel i in pbitems) {
        List<pw.Widget> _listview = [];
        for (ProductModel? j in i.productlist!) {
          _listview.add(await _list(j!));
        }
        pdf.addPage(
          pw.MultiPage(
              pageTheme: await pdftool.pagetheam(5, ispaid),
              // theme: await pdftool.theamdata(),
              // pageFormat: PdfPageFormat.a4,
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              maxPages: 200,
              // margin: pw.EdgeInsets.all(5),
              header: (pw.Context ctx) {
                return pdftool.buildHeader(i.basedon!, logoimage);
              },
              footer: (pw.Context ctx) {
                return pdftool.buildFooter(
                    context: ctx,
                    contactno: contactno,
                    companyname: companyname);
              },
              build: (context) => [
                    // pw.Padding(
                    //     padding: pw.EdgeInsets.only(left: 15, right: 15),
                    //     child:
                    pw.Wrap(
                        children: _listview,
                        spacing: 5,
                        // alignment: pw.WrapAlignment.start,
                        // crossAxisAlignment: pw.WrapCrossAlignment.start,
                        // runAlignment: pw.WrapAlignment.spaceBetween,
                        runSpacing: 5)
                    // )
                  ]),
        );
      }
    }

    Future savePdf() async {
      try {
        await writeOnPdf();
        Directory documentDirectory = await getApplicationDocumentsDirectory();
        String documentPath = documentDirectory.path;
        filepath = "$documentPath/ProductCatalogue5.pdf";
        File file = File(filepath);
        file.writeAsBytesSync(await pdf.save());
        pdfdoc = await PDFDocument.fromFile(File(filepath));
      } catch (e) {
        print('Error on gpv :: $e');
      }
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
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => ViewAdToDownload(
                      //               filepath: filepath,
                      //               ispaid: ispaid,
                      //             )));
                    },
                  )
                ],
              ),
              body: (pdfdoc == null)
                  ? Center(child: Text('Sorry,Error Creating PDF'))
                  : PDFViewer(document: pdfdoc!, showNavigation: true));
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
                Text('''Your Catalogue is Preparing.
It will tak a while if your product has many Images''',
                    textAlign: TextAlign.center)
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
