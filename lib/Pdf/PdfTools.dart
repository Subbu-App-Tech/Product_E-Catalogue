import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import '../Models/ProductModel.dart';
import '../Models/VarietyProductModel.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/services.dart';

class ProcuctbasedModel {
  String? basedon;
  List<ProductModel?>? productlist;
  ProcuctbasedModel({this.basedon, this.productlist});
}

class Pdftools {
  static Future createInterstitialAd() async {
    InterstitialAd? _interstitialAd;
    await InterstitialAd.load(
        // adUnitId: InterstitialAd.testAdUnitId,
        adUnitId: 'ca-app-pub-9568938816087708/7976666598',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) async => await ad.show(),
          onAdFailedToLoad: (LoadAdError error) {},
        ));
    if (_interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
  }

  pw.Widget buildFooter(
      {pw.Context? context, String? companyname, String? contactno}) {
    return pw.Container(
        padding: pw.EdgeInsets.all(5),
        color: PdfColors.blue,
        width: double.infinity,
        foregroundDecoration: pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(7)),
        ),
        alignment: pw.Alignment.center,
        child: pw.Row(
            mainAxisSize: pw.MainAxisSize.max,
            children: <pw.Widget>[
              pw.Expanded(
                  child: pw.Container(
                      padding: pw.EdgeInsets.fromLTRB(0, 5, 5, 5),
                      alignment: pw.Alignment.bottomLeft,
                      child: pw.Text('$companyname, $contactno',
                          style: pw.TextStyle(
                              fontSize: 16, color: PdfColors.white)))),
              pw.Container(
                  padding: pw.EdgeInsets.fromLTRB(5, 5, 0, 5),
                  alignment: pw.Alignment.bottomRight,
                  child: pw.Text('Created with Product E-Catalogue',
                      style: pw.TextStyle(
                          fontSize: 16,
                          color: PdfColors.white,
                          fontWeight: pw.FontWeight.bold)))
            ],
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.end));
  }

  pw.Widget buildHeader(String header, PdfImage logoimage) {
    return pw.Column(children: [
      pw.Container(
          foregroundDecoration: pw.BoxDecoration(
            borderRadius: pw.BorderRadius.all(pw.Radius.circular(7)),
          ),
          padding: pw.EdgeInsets.all(15),
          alignment: pw.Alignment.center,
          color: PdfColors.blue,
          width: double.infinity,
          height: 50,
          child: pw.Row(
              children: <pw.Widget>[
                pw.Expanded(
                    child: pw.Container(
                        child: pw.Text('${header.toUpperCase()}',
                            style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold)))),
                (pw.Container(
                    height: 40,
                    width: 100,
                    child: pw.Image(pw.ImageProxy(logoimage))))
              ],
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.center)),
      pw.SizedBox(height: 10)
    ]);
  }

  List<String> validimagepath(List<String>? pathlist) {
    List<String> valid = [];
    for (String i in (pathlist ?? [])) {
      if (File(i).existsSync()) valid.add(i);
    }
    return valid;
  }

  bool checkimagepath(List<String> imagelist) {
    if (imagelist.length > 0) {
      if (validimagepath(imagelist).length > 0) {
        return true;
      } else {
        return false;
      }
    }
    return false;
  }

  pw.Widget varietytable(
      String? productid,
      Function findvardatas,
      String currency,
      double tableonewidth,
      double tabletwowidth,
      int maxlistlen) {
    String? val;
    List<VarietyProductM>? varietylist;
    if (currency != '') {
      val = 'Price';
    } else {
      val = 'Price in $val';
    }
    final tableHeaders = ['Varietes', '$val'];
    varietylist = findvardatas(productid);
    if (varietylist!.length > maxlistlen) {
      varietylist = varietylist.sublist(0, maxlistlen);
    }
    return pw.Table.fromTextArray(
        cellPadding: pw.EdgeInsets.all(2),
        border: pw.TableBorder(
            // color: PdfColors.grey200,
            horizontalInside: pw.BorderSide.none,
            bottom: pw.BorderSide.none,
            left: pw.BorderSide.none,
            right: pw.BorderSide.none,
            verticalInside: pw.BorderSide(),
            top: pw.BorderSide.none),
        headerCount: 1,
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: List<List<String>>.generate(
          varietylist.length,
          (row) => List<String>.generate(
            tableHeaders.length,
            (col) {
              // print(varietylist[row].varityname);
              return varietylist![row].getIndex(col);
            },
          ),
        ),
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerRight
        },
        headerAlignments: {0: pw.Alignment.center, 1: pw.Alignment.center},
        columnWidths: {
          0: pw.FixedColumnWidth(tableonewidth),
          1: pw.FixedColumnWidth(tabletwowidth)
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 10,
          fontWeight: pw.FontWeight.bold,
        ),
        headerDecoration: pw.BoxDecoration(
          color: PdfColors.blue600,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 10,
        ),
        oddRowDecoration: pw.BoxDecoration(color: PdfColors.grey400),
        rowDecoration: pw.BoxDecoration(color: PdfColors.grey200));
  }

  Future<void> download(BuildContext context, SnackBar snackBar,
      GlobalKey<ScaffoldState> _scaffoldkey) async {
    if (await Permission.storage.request().isGranted) {
      // var dir = await ExtStorage.getExternalStoragePublicDirectory(
      // ExtStorage.DIRECTORY_DOWNLOADS);
      var dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      File file = await new File("$dir/ProductDataTemplate.csv")
          .create(recursive: true);
      var isExist = await file.exists();
      if (isExist) {
        snackBar = SnackBar(
            content:
                Text('Template Downloaded Succesfully in Download folder..!'));
        _scaffoldkey.currentState!.showSnackBar(snackBar);
        // return
      } else {
        snackBar =
            SnackBar(content: Text('Sorry, Error in Template Downloaded..!'));
        _scaffoldkey.currentState!.showSnackBar(snackBar);
      }
    }
  }

  Future<pw.PageTheme> pagetheam(double val, bool ispaid) async {
    return pw.PageTheme(
        buildBackground: (pw.Context context) {
          return pw.FullPage(
            ignoreMargins: true,
            child: pw.Watermark.text(ispaid ? '' : 'Product E-Catalogue',
                fit: pw.BoxFit.contain,
                style: pw.TextStyle(
                    fontSize: 40,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.grey200)),
          );
        },
        theme: pw.ThemeData.withFont(
            base: pw.Font.ttf(
                await rootBundle.load("assets/Open_Sans/OpenSans-Regular.ttf")),
            bold: pw.Font.ttf(
                await rootBundle.load("assets/Open_Sans/OpenSans-Bold.ttf")),
            boldItalic: pw.Font.ttf(await rootBundle
                .load("assets/Open_Sans/OpenSans-BoldItalic.ttf")),
            italic: pw.Font.ttf(
                await rootBundle.load("assets/Open_Sans/OpenSans-Italic.ttf"))),
        margin: pw.EdgeInsets.all(val),
        pageFormat: PdfPageFormat.a4);
  }

  Future<pw.ThemeData> theamdata() async {
    return pw.ThemeData.withFont(
        base: pw.Font.ttf(
            await rootBundle.load("assets/Open_Sans/OpenSans-Regular.ttf")),
        bold: pw.Font.ttf(
            await rootBundle.load("assets/Open_Sans/OpenSans-Bold.ttf")),
        boldItalic: pw.Font.ttf(
            await rootBundle.load("assets/Open_Sans/OpenSans-BoldItalic.ttf")),
        italic: pw.Font.ttf(
            await rootBundle.load("assets/Open_Sans/OpenSans-Italic.ttf")));
  }

  List<ProductModel?>? sortedlist(
      {List<ProductModel?>? list,
      String? type,
      Function? functofindvarietycount}) {
    if (list != null) if (type == 'rank') {
      return list..sort((a, b) => a!.rank!.compareTo(b!.rank!));
    } else if (type == 'variety') {
      return list
        ..sort((a, b) => functofindvarietycount!(a!.id)
            .compareTo(functofindvarietycount(b!.id)));
    } else if (type == 'name') {
      return list
        ..sort(
            (a, b) => a!.name!.toLowerCase().compareTo(b!.name!.toLowerCase()));
    } else if (type == 'none') {
      return list;
    }
    return [];
  }
}
