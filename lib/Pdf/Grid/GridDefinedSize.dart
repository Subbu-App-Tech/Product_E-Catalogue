import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:productcatalogue/UPI_Transaction.dart';
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
import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import '../../Models/SecureStorage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:productcatalogue/Widgets/Group/Toast.dart';

class PDFGriddefinedsize extends StatefulWidget {
  static const routeName = '/PDFGriddefinedsize';
  const PDFGriddefinedsize({Key? key}) : super(key: key);

  @override
  _PDFGriddefinedsizeState createState() => _PDFGriddefinedsizeState();
}

class _PDFGriddefinedsizeState extends State<PDFGriddefinedsize> {
  @override
  void initState() {
    Pdftools.createInterstitialAd();
    super.initState();
  }

  String filepath = '';
  pw.Document pdf = pw.Document();

  @override
  Widget build(BuildContext context) {
    PdfImage image;
    Uint8List list;
    Pdftools pdftool = Pdftools();
    List<CategoryModel> category = Provider.of<CategoryData>(context).items;
    List<ProcuctbasedModel> pbitems = [];
    Function varietyrangefunc = Provider.of<VarietyData>(context).minmaxvalue;
    Function findvardata = Provider.of<VarietyData>(context).findbyid;
    List<Brandcount> uqbrand = Provider.of<ProductData>(context).uqbrand();
    SecureStorage storage = SecureStorage();
    String currency;
    late PDFDocument _pdfdoc;
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
      String val = currency;
      ByteData bytes = await rootBundle.load('assets/productc.png');
      Uint8List logo = bytes.buffer.asUint8List();
      PdfImage logoimage = PdfImage.file(pdf.document, bytes: logo);

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
        List<String> pathlist = pdftool
            .validimagepath(productdata.imagepathlist?.cast<String>() ?? []);
        if (pathlist.length > 0) {
          list = await new File(pathlist[0]).readAsBytes();
          image = PdfImage.file(pdf.document, bytes: list);
        } else {
          ByteData bytes = await rootBundle.load('assets/NoImage.png');
          list = bytes.buffer.asUint8List();
        }
        image = PdfImage.file(pdf.document, bytes: list);

        return pw.Container(
            alignment: pw.Alignment.center,
            // color: PdfColors.grey100,
            padding: pw.EdgeInsets.all(4),
            width: 195,
            child: pw.Column(
                mainAxisSize: pw.MainAxisSize.max,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: <pw.Widget>[
                  pw.Container(
                    width: 180,
                    height: 80,
                    foregroundDecoration: pw.BoxDecoration(
                        borderRadius:
                            pw.BorderRadius.all(pw.Radius.circular(5)),
                        border: pw.Border.all(color: PdfColors.grey500)),
                    alignment: pw.Alignment.center,
                    padding: pw.EdgeInsets.all(1.5),
                    child: pw.Image(pw.ImageProxy(image),
                        fit: pw.BoxFit.contain, height: 80, width: 180),
                  ),
                  pw.SizedBox(height: 0.5),
                  pw.Container(
                    padding: pw.EdgeInsets.all(2),
                    child: pw.Text('${productdata.name}',
                        style: pw.TextStyle(
                            fontSize: 15, fontWeight: pw.FontWeight.bold)),
                  ),
                  pw.SizedBox(height: 0.5),
                  (productdata.brand == null || productdata.brand == '')
                      ? pw.SizedBox.shrink()
                      : pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'Brand :-  ${productdata.brand}',
                            style: pw.TextStyle(fontSize: 10),
                          )),
                  (findvardata(productdata.id).length == 0)
                      ? pw.SizedBox(height: 0.5)
                      : pw.Container(
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text(
                            'No of variety: ${findvardata(productdata.id).length}',
                            style: pw.TextStyle(fontSize: 12),
                          )),
                  pw.SizedBox(height: 0.5),
                  pw.Container(
                      width: 158,
                      height: 15,
                      child:
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                        pw.Text((priceB == null) ? 'Price' : 'Price Range',
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold, fontSize: 10)),
                        pw.Expanded(
                            child: (priceB == null)
                                ? pw.FittedBox(
                                    alignment: pw.Alignment.centerLeft,
                                    fit: pw.BoxFit.contain,
                                    child: pw.Text('  $currency  $priceA',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.red400),
                                        maxLines: 1))
                                : pw.FittedBox(
                                    alignment: pw.Alignment.centerRight,
                                    fit: pw.BoxFit.contain,
                                    child: pw.Text('  $val $priceA - $priceB',
                                        style: pw.TextStyle(
                                            fontWeight: pw.FontWeight.bold,
                                            color: PdfColors.red400),
                                        maxLines: 1)))
                      ])),
                  pw.Container(
                      height: 78,
                      width: double.infinity,
                      padding: pw.EdgeInsets.only(
                          bottom: 2, top: 2, left: 2, right: 2),
                      alignment: pw.Alignment.topLeft,
                      child: pw.Paragraph(
                          padding: pw.EdgeInsets.all(1),
                          text: '''${productdata.description}''',
                          style: pw.TextStyle(
                            fontSize: 9,
                          ),
                          textAlign: pw.TextAlign.justify))
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
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              maxPages: 200,
              header: (pw.Context ctx) =>
                  pdftool.buildHeader(i.basedon!, logoimage),
              footer: (pw.Context ctx) {
                return pdftool.buildFooter(
                    context: ctx,
                    contactno: contactno,
                    companyname: companyname);
              },
              build: (context) =>
                  [pw.Wrap(children: _listview, spacing: 1, runSpacing: 1)]),
        );
      }
    }

    Future savePdf() async {
      if (await Permission.storage.isDenied) {
        PermissionStatus status = await Permission.storage.request();
        if (status.isDenied) {
          Toast.show('Permission Denied Cant able to create file', context);
          return;
        }
      }
      await writeOnPdf();
      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      filepath = "$documentPath/ProductCatalogue1.pdf";
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => Upitransactionpage(
                                  filepath: filepath, ispaid: ispaid)));
                    },
                  )
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

// Scaffold(
//       body: FutureBuilder(
//         future: savePdf(),
//         builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return PDFViewerScaffold(
//               appBar: AppBar(
//                 centerTitle: true,
//                 title: Text('PDF'),
//               ),
//               path: filepath,
//             );
//           } else {
//             return Scaffold(
//                 appBar: AppBar(
//                   centerTitle: true,
//                   title: Text('Waiting Screen'),
//                 ),
//                 body: Center(child: CircularProgressIndicator()));
//           }
//         },
//       ),
//     )
