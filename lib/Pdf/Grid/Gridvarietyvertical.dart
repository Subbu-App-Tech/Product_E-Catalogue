import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../Provider/ProductDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../PdfTools.dart';

Future<Uint8List> gridVarietyVertPv(
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
      image = PdfImage.file(pdf.document, bytes: list);
    } else {
      ByteData bytes = await rootBundle.load('assets/NoImage.png');
      list = bytes.buffer.asUint8List();
    }
    image = PdfImage.file(pdf.document, bytes: list);

    return pw.Container(
        width: 280,
        padding: pw.EdgeInsets.all(3),
        child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Container(
                  width: double.infinity,
                  padding: pw.EdgeInsets.all(5),
                  child: pw.Text(' ${productdata.name}',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(
                          fontSize: 15,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white)),
                  color: PdfColors.blueAccent),
              pw.SizedBox(height: 2),
              pw.Row(
                  mainAxisSize: pw.MainAxisSize.min,
                  mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 100,
                      alignment: pw.Alignment.center,
                      padding: pw.EdgeInsets.all(1),
                      child: pw.Image(pw.ImageProxy(image),
                          fit: pw.BoxFit.contain, width: 70),
                    ),
                    pw.SizedBox(width: 5),
                    productdata.varieties.isEmpty
                        ? pw.SizedBox(width: 0.5)
                        : pw.Container(
                            alignment: pw.Alignment.topCenter,
                            width: 166,
                            child: pdftool.varietytable(
                                productdata, currency, 112, 53, 20)),
                  ]),
            ]));
  }

  for (ProcuctbasedModel i in prodItems) {
    List<pw.Widget> _listview = [];
    for (Product? j in i.productlist) _listview.add(await _list(j!));
    pdf.addPage(
      pw.MultiPage(
          pageTheme: await pdftool.pagetheam(5, ispaid),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          header: (pw.Context ctx) {
            return pdftool.buildHeader(i.basedon!, logoimage);
          },
          footer: (pw.Context ctx) {
            return pdftool.buildFooter(
                context: ctx, contactno: contactno, companyname: companyname);
          },
          build: (context) =>
              [pw.Wrap(children: _listview, spacing: 7, runSpacing: 7)]),
    );
  }
  return pdf.save();
}
