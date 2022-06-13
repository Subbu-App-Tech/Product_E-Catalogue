import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:productcatalogue/adMob/my_ad_mod.dart';
import '../Provider/ProductDataP.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'dart:io';
import '../Pdf/PDFhomepage.dart';

String localeName = Platform.localeName;

class ExportData extends StatelessWidget {
  static const routeName = '/export_data';
  const ExportData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey =
        new GlobalKey<ScaffoldState>();
    SnackBar snackBar;
    List<Product> productdata = Provider.of<ProductData>(context).items;

    Future export(BuildContext context) async {
      List<List<dynamic>> rows = [];
      rows.add(Product.header);
      productdata.forEach((p) {
        rows.addAll(p.toList);
      });

      Permission.storage.request();
      try {
        await MyMobAd().showInterstitialAd();
        if (await Permission.storage.request().isGranted) {
          var dir = await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
          Directory ddir =
              await Directory('$dir/$AppName').create(recursive: true);
          File f = await new File("${ddir.path}/Product_Data.csv")
              .create(recursive: true);
          String csv = const ListToCsvConverter().convert(rows);
          snackBar = SnackBar(
              content: Text('Data Exported Succesfully to $AppName folder..!'));
          await f.writeAsString(csv);
          // ignore: deprecated_member_use
          _scaffoldkey.currentState!.showSnackBar(snackBar);
          OpenFile.open(f.path);
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text('Import Export Data')),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Export Data as CSV'),
                  subtitle: Text('Export all your product date into csv'),
                  onTap: () {
                    export(context);
                  },
                )),
              ),
              Divider(),
              Text(
                'Download Product Catalogue',
                style: TextStyle(fontSize: 20),
              ),
              Divider(),
              PDFDicv(ispaid: false),
              SizedBox(height: 10),
              Divider(),
              Text('Download PDF Without WaterMark',
                  style: TextStyle(fontSize: 20)),
              Divider(),
              PDFDicv(ispaid: true),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
        // try {
        //   Directory appDir = await pPath.getApplicationDocumentsDirectory();
        //   Directory csvdir = await Directory('${appDir.path}/ProductDataCSV')
        //       .create(recursive: true);
        //   File file = await new File("${csvdir.path}/Product_Data.csv")
        //       .create(recursive: true);
        //   String? output = await showDialog(
        //       context: context,
        //       builder: (BuildContext context) => _errorondownload(context));
        //   bool isExist = await file.exists();
        //   if (output == 'saved') {
        //     if (isExist) {
        //       String csv = const ListToCsvConverter().convert(rows);
        //       snackBar =
        //           SnackBar(content: Text('CSV exported to App Directory..!'));
        //       // ignore: deprecated_member_use
        //       _scaffoldkey.currentState!.showSnackBar(snackBar);
        //       await file.writeAsString(csv);
        //       OpenFile.open(file.path);
        //     } else {
        //       snackBar =
        //           SnackBar(content: Text('Sorry, Error in Exporting Data..!'));
        //     }
        //   } else {
        //     snackBar = SnackBar(content: Text('Sorry, Error -> $e'));
        //   }
        // } catch (ee) {
        //   snackBar = SnackBar(content: Text('Sorry, Error -> $ee'));
        // }
        // ignore: deprecated_member_use
        // _scaffoldkey.currentState!.showSnackBar(snackBar);
      // Widget _errorondownload(BuildContext context) {
      //   return AlertDialog(
      //     title: Text('Error Downloading'),
      //     content: Column(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Text('Can\'t able to download in Download Directory '
      //             '\nClick below to save CSV to App Directory'),
      //         SizedBox(height: 7),
      //         // ignore: deprecated_member_use
      //         RaisedButton(
      //           color: Colors.green,
      //           child: Padding(
      //             padding: const EdgeInsets.all(5),
      //             child: Text('Save CSV in App Directory',
      //                 textAlign: TextAlign.center,
      //                 style: TextStyle(color: Colors.white)),
      //           ),
      //           onPressed: () {
      //             Navigator.of(context).pop('saved');
      //           },
      //         ),
      //       ],
      //     ),
      //   );
      // }
