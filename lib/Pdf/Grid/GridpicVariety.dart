import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../Provider/ProductDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../PdfTools.dart';

Future<Uint8List> gridPicVariety(
    List<ProcuctbasedModel> prodItems, bool ispaid) async {
  final pdf = pw.Document();
  Pdftools pdftool = Pdftools();
  final currency = await storage.getcurrency();
  final contactno = await storage.getcontactno();
  final companyname = await storage.getcompanyname();
  ByteData bytes = await rootBundle.load('assets/productc.png');
  Uint8List logo = bytes.buffer.asUint8List();
  PdfImage logoimage = PdfImage.file(pdf.document, bytes: logo);

  Future<pw.Widget> _list(Product productdata) async {
    PdfImage image;
    Uint8List list;
    final List<double> varietyrange = productdata.minMaxPrice;
    String? priceA;
    String? priceB;
    if (varietyrange[0] == varietyrange[1]) {
      priceA = varietyrange[0].toString();
      priceB = null;
    } else if (varietyrange[0] != varietyrange[1]) {
      priceA = varietyrange[0].toString();
      priceB = varietyrange[1].toString();
    }
    List<String> pathlist = pdftool.validimagepath(productdata.imagepathlist);
    if (pathlist.length > 0) {
      list = await new File(pathlist[0]).readAsBytes();
      image = PdfImage.file(pdf.document, bytes: list);
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
            productdata.varieties.isEmpty
                ? pw.SizedBox(width: 0.5)
                : pw.Container(
                    width: double.infinity,
                    child: pdftool.varietytable(
                        productdata, currency, 110, 65, 27)),
            pw.SizedBox(width: 2),
          ]),
    );
  }

  for (ProcuctbasedModel i in prodItems) {
    List<pw.Widget> _listview = [];
    for (Product? j in i.productlist) {
      _listview.add(await _list(j!));
    }
    pdf.addPage(
      pw.MultiPage(
          pageTheme: await pdftool.pagetheam(5, ispaid),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          maxPages: 200,
          header: (pw.Context ctx) =>
              pdftool.buildHeader(i.basedon!, logoimage),
          footer: (pw.Context ctx) {
            return pdftool.buildFooter(
                context: ctx, contactno: contactno, companyname: companyname);
          },
          build: (context) =>
              [pw.Wrap(children: _listview, spacing: 5, runSpacing: 5)]),
    );
  }
  return pdf.save();
}
