import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../Provider/ProductDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../PdfTools.dart';

Future<Uint8List> listViewOne(
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
        width: 575,
        padding: pw.EdgeInsets.all(2.5),
        foregroundDecoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
            border: pw.Border.all(width: 1)),
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
            mainAxisAlignment: pw.MainAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                alignment: pw.Alignment.center,
                padding: pw.EdgeInsets.all(2.5),
                width: 140,
                child: pw.Image(pw.ImageProxy(image), fit: pw.BoxFit.contain),
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
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
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
                                      (productdata.description!.isEmpty)
                                          ? pw.SizedBox.shrink()
                                          : pw.Container(
                                              alignment: pw.Alignment.topLeft,
                                              child: pw.Text(
                                                  'Product Description',
                                                  style: pw.TextStyle(
                                                      fontSize: 12))),
                                      (productdata.description!.isEmpty)
                                          ? pw.SizedBox.shrink()
                                          : pw.Container(
                                              // color: PdfColors.grey200,
                                              width: 200,
                                              alignment: pw.Alignment.topLeft,
                                              child: pw.Paragraph(
                                                  text:
                                                      '''${productdata.description}''',
                                                  style: pw.TextStyle(
                                                    fontSize: 10,
                                                  ),
                                                  textAlign:
                                                      pw.TextAlign.justify)),
                                    ])),
                                (productdata.varieties.length == 0)
                                    ? pw.SizedBox(width: 0.5)
                                    : pw.Container(
                                        padding:
                                            pw.EdgeInsets.fromLTRB(5, 2, 5, 2),
                                        alignment: pw.Alignment.topCenter,
                                        child: pdftool.varietytable(productdata,
                                            currency, 150, 60, 37)),
                              ]),
                        )
                      ])),
            ]));
  }

  for (ProcuctbasedModel i in prodItems) {
    List<pw.Widget> _listview = [];
    for (Product j in i.productlist) {
      _listview.add(await _list(j));
    }
    pdf.addPage(
      pw.MultiPage(
          pageTheme: await pdftool.pagetheam(5, ispaid),
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          maxPages: 200,
          header: (pw.Context ctx) {
            return pdftool.buildHeader(i.basedon!, logoimage);
          },
          footer: (pw.Context ctx) {
            return pdftool.buildFooter(
                context: ctx, contactno: contactno, companyname: companyname);
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
  return pdf.save();
}
