import 'package:flutter/material.dart';
import '../Widgets/Drawer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'dart:convert';
import 'dart:async';
import '../Models/CategoryModel.dart';
import '../Models/ProductModel.dart';
import '../Models/VarietyProductModel.dart';
import 'package:provider/provider.dart';
import '../Provider/CategoryDataP.dart';
import '../Provider/ProductDataP.dart';
import '../Provider/VarietyDataP.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Tool/Helper.dart';
import '../Screens/Export.dart';
import '../Screens/Settingscreen.dart';
import '../contact/Aboutus.dart';
import '../contact/Contactus.dart';
import 'package:flutter/services.dart';
import 'package:external_path/external_path.dart';
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart' as pr;

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
  String? out;
  bool? importdatastatus;
  bool? importeddatastatus;
  List<List<dynamic>> importeddata = [];
  @override
  void initState() {
    importdata = 0;
    importdatastatus = false;
    super.initState();
  }

  Future savedataa(String filepath) async {
    importeddatastatus = false;
    try {
      final input = new File(filepath).openRead();
      final fields = await input
          .transform(utf8.decoder)
          .transform(new CsvToListConverter())
          .toList();
      // print(fields);
      importeddata = fields;
      List<String> header = [
        'name',
        'description',
        'brand',
        'category',
        'varietyname',
        'varietyprice',
        'varietywsp',
        'rank',
        'imagefilename'
      ];
      List<ProductModel> productdata = [];
      List<CategoryModel> catdata = [];
      List<VarietyProductM> vardata = [];
      List<String> catnamedata = [];

      Future<void> validate(datafield) async {
        String appDirs = await ExternalPath.getExternalStoragePublicDirectory(
            ExternalPath.DIRECTORY_DOWNLOADS);
        Directory imagedir =
            await Directory('$appDirs/Product E-catalogue/Product Pictures')
                .create(recursive: true);
        if (helper.areListsEqual(datafield[0], header)) {
          {
            for (List i in fields) {
              if (i[0] == 'name' || i[1] == 'description') {
              } else {
                if (helper.stringval(i[0]) != null ||
                    helper.stringval(i[4]) != null) {
                  if (helper.stringval(i[0])!.trim() != '' ||
                      helper.stringval(i[4])!.trim() != '') {
                    final prodid = UniqueKey().toString();
                    List<String> catid(String? catstring) {
                      List<String?> _catid = [];
                      if (catstring == null || catstring.trim() == '') {
                        return ['otherid'];
                      } else {
                        for (String k in catstring.split(',')) {
                          if (catnamedata.contains(k.trim())) {
                            _catid.add(catdata
                                .firstWhere((f) => f.name == k.trim())
                                .id);
                          } else {
                            String _cid = UniqueKey().toString();
                            catnamedata.add(k.trim());
                            catdata
                                .add(CategoryModel(id: _cid, name: k.trim()));
                            _catid.add(_cid);
                          }
                        }
                        _catid.removeWhere((e) => e == null);
                        return _catid.map((e) => e!).toList();
                      }
                    }

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
                            print('>>>>>>>>>>>>>>>>>>>>>>>>>>> $pathlist');
                          }
                        }
                        return pathlist;
                      }
                    }

                    ProductModel prodmod = ProductModel(
                        id: prodid,
                        name: helper.stringval(i[0]),
                        rank: helper.intval(i[7]),
                        brand: helper.stringval(i[2]),
                        description: helper.stringval(i[1]),
                        categorylist: catid(i[3]),
                        imagepathlist: imageinput(i[8]));
                    if (helper.iscontains(productdata, prodmod)) {
                      if (i[4] == null || i[4].trim() == '') {
                      } else {
                        vardata.add(VarietyProductM(
                            productid: productdata
                                .firstWhere((f) => helper.isequal(f, prodmod))
                                .id,
                            id: UniqueKey().toString(),
                            varityname: helper.stringval(i[4]),
                            price: helper.doubleval(i[5]),
                            wsp: helper.doubleval(i[6])));
                      }
                    } else {
                      productdata.add(prodmod);
                      vardata.add(VarietyProductM(
                          productid: prodid,
                          id: UniqueKey().toString(),
                          varityname: helper.stringval(i[4]),
                          price: helper.doubleval(i[5]),
                          wsp: helper.doubleval(i[6])));
                    }
                    out = 'Data Uploaded Succesfully..!';
                  }
                  out = 'Error on Data..!';
                }
                out = 'Error on Data..!';
                if (helper.stringval(i[0]) != null ||
                    helper.stringval(i[4]) != null) {
                  out = 'Porduct Must have atleast one Variety Name';
                }
              }
            }
            setState(() {
              importdata = productdata.length;
              Provider.of<ProductData>(context, listen: false)
                  .addallproduct(productdata);
              Provider.of<VarietyData>(context, listen: false)
                  .addallvarity(vardata);
              Provider.of<CategoryData>(context, listen: false)
                  .addallcategory(catdata);
              // out = 'Data Uploaded Succesfully..!';
            });
            if (importdata! > 0) {
              out = '$importdata Data Uploaded Succesfully..!';
            } else {
              out = 'No Valid Data to Upload..!';
            }
            // out = 'No Valid !';
          }
          out = 'No Valid Data to Upload..!';
          importeddatastatus = true;
          setState(() {});
        } else {
          out = 'Please check the template Formate..!';
          setState(() {});
        }
      }

      validate(fields);
    } catch (e) {
      importeddatastatus = true;
      print('>>> $e');
      out = '''Error in Document formate ''';
      return output = '';
    }
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
      setState(() {
        importdatastatus = true;
        savedataa(filePath).whenComplete(() {
          if (out != null) {
            snackBar = SnackBar(content: Text(out!));
            // ignore: deprecated_member_use
            _scaffoldkey.currentState!.showSnackBar(snackBar);
          }
        });
      });
    } catch (e) {
      snackBar = SnackBar(content: Text(' 😔 Error Uploading Data! :: $e'));
      setState(() {});
      // ignore: deprecated_member_use
      _scaffoldkey.currentState!.showSnackBar(snackBar);
    }
  }

  Future<void> emptydownload(BuildContext context) async {
    // EmptyHeader
    String result = '';
    try {
      bool isAcc = await Permission.storage.request().isGranted;
      if (!isAcc) await Permission.storage.request();
      isAcc = await Permission.storage.request().isGranted;
      String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      Directory savedDir = Directory(dir + '/Product E-catalogue');
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) await savedDir.create(recursive: true);
      File file = await File(savedDir.path + '/EmptyData.csv')
          .writeAsString(EmptyHeader);
      file.create(recursive: false);
      result =
          'Template Downloaded Succesfully in Product E-catalogue folder..!';
    } catch (e) {
      print('Error ::$e');
      result = 'Error Occurs :: $e';
    }
    // ignore: deprecated_member_use
    _scaffoldkey.currentState!.showSnackBar(SnackBar(content: Text(result)));
    // ignore: deprecated_member_use
    _scaffoldkey.currentState!.showSnackBar(snackBar);
  }

  // Widget _errorondownload(BuildContext context, String url) {
  //   return AlertDialog(
  //     title: Text('Error Downloading'),
  //     content: Column(
  //       mainAxisSize: MainAxisSize.min,
  //       children: [
  //         Text('Sorry, Some Error Occurs.'
  //             '\nDownload it Manually by copy & paste the link to your browser'),
  //         SizedBox(height: 7),
  //         // ignore: deprecated_member_use
  //         RaisedButton(
  //           color: Colors.green,
  //           child: Padding(
  //             padding: const EdgeInsets.all(5),
  //             child: Text('Click Here to Copy Download Link',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(color: Colors.white)),
  //           ),
  //           onPressed: () {
  //             print('copy');
  //             Clipboard.setData(new ClipboardData(text: url));
  //             Navigator.of(context).pop('copied');
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Future<void> downloadwithdata(BuildContext context) async {
    String result = '';
    try {
      bool isAcc = await Permission.storage.request().isGranted;
      if (!isAcc) await Permission.storage.request();
      isAcc = await Permission.storage.request().isGranted;
      String dir = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      Directory savedDir = Directory(dir + '/Product E-catalogue');
      bool hasExisted = await savedDir.exists();
      if (!hasExisted) await savedDir.create(recursive: true);
      ByteData data = await rootBundle.load('assets/SampleData.csv');
      File file = await File(savedDir.path + '/SampleData.csv')
          .writeAsBytes(data.buffer.asUint8List());
      file.create(recursive: false);
      result =
          'Template Downloaded Succesfully in Product E-catalogue folder..!';
    } catch (e) {
      print('Error ::$e');
      result = 'Error Occurs :: $e';
    }
    // ignore: deprecated_member_use
    _scaffoldkey.currentState!.showSnackBar(SnackBar(content: Text(result)));
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
    return MaterialApp(
      home: Scaffold(
        key: _scaffoldkey,
        drawer: MyDrawer(),
        appBar: AppBar(
          title: Text('Import Product Data'),
        ),
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
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5,
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
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5,
                  onPressed: () {
                    emptydownload(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      'Download Empty CSV Template',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(30, 5, 30, 10),
                alignment: Alignment.center,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  color: Colors.blue,
                  elevation: 5,
                  onPressed: () {
                    getFilePath(context);
                  },
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                          '''Product E-catalogue > Product Pictures Folder in Internal Storage''',
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
      ),
      routes: {
        ExportData.routeName: (ctx) => ExportData(),
        SettingScreen.routeName: (ctx) => SettingScreen(),
        ImportExport.routeName: (ctx) => ImportExport(),
        ContactUs.routeName: (ctx) => ContactUs(),
        AboutUs.routeName: (ctx) => AboutUs()
      },
    );
  }
}

const String EmptyHeader =
    'name,description,brand,category,varietyname,varietyprice,varietywsp,rank,imagefilename';
// Future<void> downloadwithdata(BuildContext context) async {
//   String url = 'https://firebasestorage.googleapis.com/v0/b/'
//       'product-catalogue-app-f7bf8.appspot.com/o/Cataloguetemplatewithdata.csv'
//       '?alt=media&token=df899fc0-f74f-4613-ab74-30350801776b';
//   try {
//     print(await Permission.storage.status);
//     bool isAcc = await Permission.storage.request().isGranted;
//     if (!isAcc) await Permission.storage.request();
//     isAcc = await Permission.storage.request().isGranted;
//     String dir = await ExternalPath.getExternalStoragePublicDirectory(
//         ExternalPath.DIRECTORY_DOWNLOADS);
//     Directory savedDir = Directory(dir + '/Product E-catalogue');
//     bool hasExisted = await savedDir.exists();
//    if (!hasExisted) await savedDir.create(recursive: true);
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult != ConnectivityResult.none) {
//       await FlutterDownloader.enqueue(
//           url: url,
//           savedDir: savedDir.path,
//           fileName: 'PECTemplatewithdata.csv',
//           showNotification: true,
//           openFileFromNotification: true);
//       snackBar = SnackBar(
//           content: Text(
//               'Template Downloaded Succesfully in Product E-catalogue folder..!'));
//     } else {
//       snackBar = SnackBar(content: Text('Check Network Connection..!'));
//     }
//   } catch (e) {
//     print('Error ::$e');
//     String? output = await showDialog(
//         context: context,
//         builder: (BuildContext context) => _errorondownload(context, url));
//     if (output == 'copied') {
//       snackBar = SnackBar(content: Text('Download link copied..!'));
//     } else {
//       snackBar = SnackBar(content: Text('Link not Copied..!'));
//     }
//   }
//   // ignore: deprecated_member_use
//   _scaffoldkey.currentState!.showSnackBar(snackBar);
// }
// Future<void> emptydownload(BuildContext context) async {
//   // EmptyHeader
//   String url =
//       'https://firebasestorage.googleapis.com/v0/b/product-catalogue-app-f7bf8.appspot.com/o/EmptyCatalogueTemplate.csv?alt=media&token=1f85a6da-8c8f-402a-bd03-2065e775ae58';
//   try {
//     if (await Permission.storage.request().isGranted) {
//       String dir = await ExternalPath.getExternalStoragePublicDirectory(
//           ExternalPath.DIRECTORY_DOWNLOADS);
//       Directory savedDir =
//           await Directory('$dir/Product E-catalogue/Sample Data')
//               .create(recursive: true);
//       bool hasExisted = await savedDir.exists();
//       if (!hasExisted) {
//         savedDir.create();
//       }
//       var connectivityResult = await (Connectivity().checkConnectivity());
//       if (connectivityResult != ConnectivityResult.none) {
//         await FlutterDownloader.enqueue(
//             url: url,
//             savedDir: savedDir.path,
//             fileName: 'PECEmptyTemplate.csv',
//             showNotification: true,
//             openFileFromNotification: true);
//         snackBar = SnackBar(
//             content: Text(
//                 'Template Downloaded Succesfully in Product E-catalogue folder..!'));
//       } else {
//         snackBar = SnackBar(content: Text('Check Network Connection..!'));
//       }
//     } else {
//       snackBar = SnackBar(content: Text('Permission Declined..!'));
//     }
//   } catch (e) {
//     print('Error');
//     String? output = await showDialog(
//         context: context,
//         builder: (BuildContext context) => _errorondownload(context, url));
//     if (output == 'copied') {
//       snackBar = SnackBar(content: Text('Download link copied..!'));
//     } else {
//       snackBar = SnackBar(content: Text('Link not Copied..!'));
//     }
//   }
//   _scaffoldkey.currentState!.showSnackBar(snackBar);
// }
