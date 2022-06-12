import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../../Provider/ProductDataP.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'dart:typed_data';
import '../PdfTools.dart';
import '../../export.dart';

Future<Uint8List> gridDefineSize(
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
    image = PdfImage.file(pdf.document, bytes: list);

    return pw.Container(
        alignment: pw.Alignment.center,
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
                    borderRadius: pw.BorderRadius.all(pw.Radius.circular(5)),
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
              productdata.varieties.isEmpty
                  ? pw.SizedBox(height: 0.5)
                  : pw.Container(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        'No of variety: ${productdata.varieties.length}',
                        style: pw.TextStyle(fontSize: 12),
                      )),
              pw.SizedBox(height: 0.5),
              pw.Container(
                  width: 158,
                  height: 15,
                  child: pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
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
                                child: pw.Text('  $priceA - $priceB',
                                    style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        color: PdfColors.red400),
                                    maxLines: 1)))
                  ])),
              pw.Container(
                  height: 78,
                  width: double.infinity,
                  padding:
                      pw.EdgeInsets.only(bottom: 2, top: 2, left: 2, right: 2),
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

  for (ProcuctbasedModel i in prodItems) {
    List<pw.Widget> _listview = [];
    for (Product? j in i.productlist) {
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
                context: ctx, contactno: contactno, companyname: companyname);
          },
          build: (context) =>
              [pw.Wrap(children: _listview, spacing: 1, runSpacing: 1)]),
    );
  }
  return pdf.save();
}
