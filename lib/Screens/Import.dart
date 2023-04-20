import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:open_file/open_file.dart';
import 'package:productcatalogue/adMob/my_ad_mod.dart';
import 'dart:convert';
import 'dart:async';
import '../Provider/ProductDataP.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Tool/Helper.dart';
import 'package:flutter/services.dart';
import 'package:external_path/external_path.dart';
import 'package:path/path.dart' as Path;

Future<File> saveFile(String fileName) async {
  bool isAcc = await Permission.storage.request().isGranted;
  if (!isAcc) await Permission.storage.request();
  isAcc = await Permission.storage.request().isGranted;
  String dir = await ExternalPath.getExternalStoragePublicDirectory(
      ExternalPath.DIRECTORY_DOWNLOADS);
  File file = await File(Path.join(dir, fileName)).create(recursive: true);
  return file;
}

class ImportExport extends StatefulWidget {
  const ImportExport({Key? key}) : super(key: key);
  static const routeName = '/import_export';

  @override
  _ImportExportState createState() => _ImportExportState();
}

class _ImportExportState extends State<ImportExport> {
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  late SnackBar snackBar;
  int? importdata;
  Helper helper = Helper();
  String? output;
  bool? importdatastatus;
  bool? importeddatastatus;
  List<List<dynamic>> importeddata = [];
  @override
  void initState() {
    importdata = 0;
    importdatastatus = false;
    super.initState();
  }

  Future<void> savedataa(String filepath) async {
    importeddatastatus = false;
    try {
      final input = new File(filepath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      importeddata = fields.sublist(1);

      int nameIdx = fields[0].indexWhere((e) => e.toString() == 'name');
      int brandIdx = fields[0].indexWhere((e) => e.toString() == 'brand');
      int descIdx = fields[0].indexWhere((e) => e.toString() == 'description');
      int categIdx = fields[0].indexWhere((e) => e.toString() == 'category');
      int vNameIdx = fields[0].indexWhere((e) => e.toString() == 'varietyname');
      int vPriceIdx =
          fields[0].indexWhere((e) => e.toString() == 'varietyprice');
      int vWSPIdx = fields[0].indexWhere((e) => e.toString() == 'varietywsp');
      int rankIdx = fields[0].indexWhere((e) => e.toString() == 'rank');
      int imgPathsIdx =
          fields[0].indexWhere((e) => e.toString() == 'imagefilename');
      if ([
        nameIdx,
        brandIdx,
        descIdx,
        categIdx,
        brandIdx,
        vNameIdx,
        vWSPIdx,
        vPriceIdx,
        rankIdx,
        imgPathsIdx
      ].contains(-1)) {
        return;
      }
      List<Product> productdata = [];
      Future<void> validate(datafield) async {
        String appDirs = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
        final ddir =
            await Directory('$appDirs//$AppName').create(recursive: true);
        Directory imagedir = await Directory('${ddir.path}//Product Pictures')
            .create(recursive: true);
        for (List i in fields) {
          if (helper.stringval(i[nameIdx]).isNotEmpty &&
              helper.stringval(i[categIdx]).isNotEmpty) {
            final prodid =
                '${UniqueKey().toString()}_${DateTime.now().microsecondsSinceEpoch}';
            List<String> imageinput(String? value) {
              const List<String> empty = [];
              if (value == null) {
                return empty;
              } else if (value.trim() == '') {
                return empty;
              } else {
                List<String> pathlist = [];
                for (String i in value.split(',')) {
                  if (i != '') {
                    pathlist.add('${imagedir.path}/$i');
                  }
                }
                return pathlist;
              }
            }

            Product prodmod = Product(
                id: prodid,
                name: i[nameIdx],
                rank: helper.intval(i[rankIdx]),
                brand: helper.stringval(i[brandIdx]),
                description: helper.stringval(i[descIdx]),
                categories: i[categIdx]?.toString().split(', ') ?? [],
                imagepathlist: imageinput(i[imgPathsIdx]));
            int iddx = productdata.indexWhere((e) =>
                e.name == prodmod.name &&
                e.categories.join(',') == prodmod.categories.join(','));
            VarietyProductM vvrr = VarietyProductM(
                productid: prodmod.id,
                id: UniqueKey().toString(),
                name: helper.stringval(i[vNameIdx]),
                price: helper.doubleval(i[vPriceIdx]) ?? 0,
                wsp: helper.doubleval(i[vWSPIdx]) ?? 0);
            if (iddx == -1) {
              prodmod.varieties.add(vvrr);
              productdata.add(prodmod);
            } else {
              vvrr.productid = productdata[iddx].id;
              productdata[iddx].varieties.add(vvrr);
            }
            BotToast.showText(text: 'Data Uploaded Succesfully..!');
          }
          BotToast.showText(text: 'Error on Data..!');
          if (helper.stringval(i[0]).isEmpty ||
              helper.stringval(i[4]).isEmpty) {
            BotToast.showText(
                text: 'Porduct Must have atleast one Variety Name');
          }
        }
        setState(() {
          importdata = productdata.length;
          Provider.of<ProductData>(context, listen: false)
              .addallproduct(productdata);
        });
        if (importdata! > 0) {
          BotToast.showText(text: '$importdata Data Uploaded Succesfully..!');
        } else {
          BotToast.showText(text: 'No Valid Data to Upload..!');
        }
      }

      BotToast.showText(text: 'No Valid Data to Upload..!');
      importeddatastatus = true;
      setState(() {});
      validate(fields);
    } catch (e) {
      importeddatastatus = true;
      BotToast.showText(
          text: 'Error Uploading: please Recheck the CSV Format \n$e');
    }
    await MyMobAd().showInterstitialAd();
  }

  void getFilePath(BuildContext context) async {
    try {
      FilePickerResult? file = await (FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['csv'],
          allowMultiple: false));
      if (file == null) return;
      String? filePath = file.files.first.path;
      print("Path: " + filePath!);
      importdatastatus = true;
      await savedataa(filePath);
      setState(() {});
    } catch (e) {
      snackBar = SnackBar(content: Text(' 😔 Error Uploading Data! :: $e'));
      // ignore: deprecated_member_use

      ScaffoldMessenger.maybeOf(context)?.showSnackBar(snackBar);
    }
    await MyMobAd().showInterstitialAd();
  }

  Future<void> emptydownload(BuildContext context) async {
    String result = '';
    try {
      final file = await saveFile('Empty_Template.csv');
      file.writeAsString(EmptyHeader);
      result = 'Template Downloaded Succesfully in $AppName folder..!';
      OpenFile.open(file.path);
    } catch (e) {
      print('Error ::$e');
      result = 'Error Occurs :: $e';
    }
    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(result)));
    await MyMobAd().showInterstitialAd();
  }

  Future<void> downloadwithdata(BuildContext context) async {
    String result = '';
    try {
      ByteData data = await rootBundle.load('assets/SampleData.csv');
      final ffile = await saveFile('Empty_Template.csv');
      await ffile.writeAsBytes(data.buffer.asUint8List());
      OpenFile.open(ffile.path);
      result = 'Template Downloaded Succesfully in $AppName folder..!';
    } catch (e) {
      print('Eoorr: $e');
      result = 'Error: $e';
    }
    // ignore: deprecated_member_use

    ScaffoldMessenger.maybeOf(context)
        ?.showSnackBar(SnackBar(content: Text(result)));
    await MyMobAd().showInterstitialAd();
  }

  Widget _header(String text) {
    return Text(
      text,
      textAlign: TextAlign.left,
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
    );
  }

  Widget _content(String text) {
    return Text(
      text,
      textAlign: TextAlign.justify,
      style: TextStyle(
          fontSize: 14, fontWeight: FontWeight.normal, wordSpacing: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text('Import Product Data')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
                onPressed: () => downloadwithdata(context),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Download CSV Template with sample data',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 10, 30, 5),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
                onPressed: () {
                  emptydownload(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('Download Empty CSV Template',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
              alignment: Alignment.center,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
                onPressed: () => getFilePath(context),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    'Import Data With CSV',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            (importeddatastatus != null)
                ? (importeddatastatus == false)
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        padding: EdgeInsets.all(5),
                        child: Container(
                          color: Colors.grey[300],
                          padding: EdgeInsets.all(10),
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: (importdata == null || importdata == 0)
                              ? Text('Error Uploading Products 😔 ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center)
                              : (importdata == 0)
                                  ? Text('No Data is there 😔',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center)
                                  : Text(
                                      '''😁 
$importdata Product Imported Successfuly 
👍''',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                        ),
                      )
                : SizedBox(height: 10),
            Container(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Column(
                children: [
                  _header('Table Column Details'),
                  SizedBox(height: 15),
                  _content('''
rank       ➔ Rank help to sort your product in Product List & also Help to Export Product Catalogue sorted by Rank

name         ➔ Name of the Product

description  ➔ Product Description

brand        ➔ Product Brand ( if you maintain your own brand leave it blank)

category     ➔ Category of the Product

varietyname  ➔ Variety Name of the Product

varietyprice  ➔ Variety Price of the Product 

varietywsp    ➔ Variety WSP of the Product

imagefilename ➔ Image files*

*Product Name with atleast one variety is essential to upload data
*Please Save Your Import CSV File in Download Folder
                    '''),
                  SizedBox(height: 10),
                  _header('Example'),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      'For Category:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '''
If Product Category Names were ‘Electronics’, ‘Mobile’ .
Then you would mention: Electronics, Mobiles .
                      ''',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      'For ImageFiles:',
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '''
If Image File Names were ‘product1.png’, ‘Product2.jpg’ .
Then you would mention: product1.png, Product2.jpg .
                      ''',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 14),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: double.infinity,
                    child: Text(
                      '* Note',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Wrap(
                    children: [
                      Text(
                        '''Image Files ➔ Image file name in the App folder. You Can find the product folder in''',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '''$AppName > Product Pictures Folder in Internal Storage''',
                        // ''' Android > data> com.subbu.productcatalogue > files > Pictures.''',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '''Save your product Images in this folder (If you can’t find “Picture” Folder. Create it [It is Case Sensitive])

* Every Text is case Sensitive.
* You can only Import New Products. can't update previously saved Products.

Hint : If you want to update products.
  1. Export product as csv
  2. Then change what you want
  3. Delete All Data
  4. Upload Updated CSV File
''',
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 25)
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const String EmptyHeader =
    'name,description,brand,category,varietyname,varietyprice,varietywsp,rank,imagefilename';
