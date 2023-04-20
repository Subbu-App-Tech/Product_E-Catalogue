import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../Provider/ProductDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../PdfTools.dart';

Future<Uint8List> gridViewPv(
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
    List<String> pathlist = pdftool.validimagepath(productdata.imagepathlist);
    if (pathlist.length > 0) {
      list = await new File(pathlist[0]).readAsBytes();
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
            border: pw.Border.all(width: 1)),
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
                  child: pw.Image(pw.ImageProxy(image), fit: pw.BoxFit.contain),
                ),
                pw.Container(
                    alignment: pw.Alignment.topCenter,
                    width: 188,
                    child: pw.Column(
                        mainAxisSize: pw.MainAxisSize.min,
                        mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: <pw.Widget>[
                          ((productdata.getDesc).isEmpty)
                              ? pw.SizedBox.shrink()
                              : pw.Container(
                                  padding: pw.EdgeInsets.only(
                                      bottom: 2, top: 2, left: 2, right: 2),
                                  alignment: pw.Alignment.topLeft,
                                  child: pw.Paragraph(
                                      padding: pw.EdgeInsets.all(1),
                                      text: '''${productdata.getDesc}''',
                                      style: pw.TextStyle(
                                        fontSize: 8,
                                      ),
                                      textAlign: pw.TextAlign.justify)),
                          (productdata.brand == null || productdata.brand == '')
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
                          productdata.varieties.isEmpty
                              ? pw.SizedBox.shrink()
                              : pw.Container(
                                  alignment: pw.Alignment.center,
                                  child: pdftool.varietytable(
                                      productdata, currency, 115, 55, 35)),
                        ])),
              ])
            ]));
  }

  for (ProcuctbasedModel i in prodItems) {
    List<pw.Widget> _listview = [];
    for (Product? j in i.productlist) {
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
                context: ctx, contactno: contactno, companyname: companyname);
          },
          build: (context) =>
              [pw.Wrap(children: _listview, spacing: 5, runSpacing: 5)]),
    );
  }
  return pdf.save();
}
