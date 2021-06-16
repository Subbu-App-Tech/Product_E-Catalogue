import 'package:flutter/material.dart';
import '../Widgets/Drawer.dart';
import '../Models/ProductModel.dart';
import '../Models/VarietyProductModel.dart';
import 'package:provider/provider.dart';
import '../Provider/CategoryDataP.dart';
import '../Provider/ProductDataP.dart';
import '../Provider/VarietyDataP.dart';
import 'package:csv/csv.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:external_path/external_path.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../Pdf/Grid/GridViewPV.dart';
import '../Pdf/Grid/Gridonlypicdesc.dart';
import '../Pdf/Grid/Gridvarietyvertical.dart';
import '../Pdf/Grid/GridDefinedSize.dart';
import '../Pdf/Grid/GridpicVariety.dart';
import '../Pdf/ListView/Listviewone.dart';
import '../Pdf/PDFhomepage.dart';
import '../Screens/Import.dart';
import '../contact/Aboutus.dart';
import '../contact/Contactus.dart';
import '../Screens/Settingscreen.dart';
import 'package:path_provider/path_provider.dart' as pPath;

String localeName = Platform.localeName;

class ExportData extends StatelessWidget {
  static const routeName = '/export_data';
  const ExportData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExportD(),
      routes: {
        PDFListviewone.routeName: (ctx) => PDFListviewone(),
        PDFGridViewPV.routeName: (ctx) => PDFGridViewPV(),
        PDFGridPicDecs.routeName: (ctx) => PDFGridPicDecs(),
        PDFGridpicVarietyVertical.routeName: (ctx) =>
            PDFGridpicVarietyVertical(),
        PDFGriddefinedsize.routeName: (ctx) => PDFGriddefinedsize(),
        PDFGridpicVarietyonly.routeName: (ctx) => PDFGridpicVarietyonly(),
        PDFbrandscatlogue.routeName: (ctx) => PDFbrandscatlogue(),
        ImportExport.routeName: (ctx) => ImportExport(),
        SettingScreen.routeName: (ctx) => SettingScreen(),
        ExportData.routeName: (ctx) => ExportData(),
        ContactUs.routeName: (ctx) => ContactUs(),
        AboutUs.routeName: (ctx) => AboutUs()
      },
    );
  }
}

class ExportD extends StatelessWidget {
  const ExportD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldkey =
        new GlobalKey<ScaffoldState>();
    SnackBar snackBar;
    List<ProductModel?> productdata = Provider.of<ProductData>(context).items;
    List<VarietyProductM> vardata = Provider.of<VarietyData>(context).items;

    String output(var val) {
      if (val == null) {
        return '';
      } else if (val.runtimeType == String) {
        return val;
      } else {
        return val.toString();
      }
    }

    Future export(BuildContext context) async {
      List<String?> prodid = [];
      List<String> name = [];
      List<String> description = [];
      // List<String> price = [];
      List<String> varietywsp = [];
      List<String> brand = [];
      List<String> category = [];
      List<String> varietyname = [];
      List<String> varietyprice = [];
      List<String> rank = [];
      List<String> imagefilename = [];
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

      String catstr(var categorylist) {
        List catnamelist = Provider.of<CategoryData>(context, listen: false)
            .findcategorylist(categorylist);
        if (catnamelist == null || catnamelist.length == 0) {
          return '';
        } else if (catnamelist.length == 1) {
          return catnamelist[0];
        } else {
          return catnamelist.join(',');
        }
      }

      String filenamelist(List<String>? list) {
        List filename = [];
        if (list == null) {
          return '';
        } else if (list.length == 0) {
          return '';
        } else {
          for (String i in list) {
            // print(i);
            // print(basename(i));
            if (i != null) {
              if (basename(i) != '') {
                filename.add(basename(i));
              }
            }
          }
          return filename.join(',');
        }
      }

      void productd(String? idx) {
        ProductModel prod = productdata.firstWhere((f) => f!.id == idx)!;
        name.add(output(prod.name));
        description.add(output(prod.description));
        rank.add(output(prod.rank));
        brand.add(output(prod.brand));
        category.add(output(catstr(prod.categorylist)));
        imagefilename.add(filenamelist(prod.imagepathlist as List<String>?));
      }

      for (VarietyProductM i in vardata) {
        varietyname.add(output(i.varityname));
        varietyprice.add(output(i.price));
        varietywsp.add(output(i.wsp));
        prodid.add(i.productid);
        productd(i.productid);
      }

      for (ProductModel? i in productdata) {
        if (!prodid.contains(i!.id)) {
          varietyname.add('');
          varietyprice.add('');
          varietywsp.add('');
          prodid.add(i.id);
          productd(i.id);
        }
      }
      List<List<dynamic>> rows = [];
      rows.add(header);

      if (name.length == varietyname.length && category.length == name.length) {
        for (int i = 0; i < name.length; i++) {
          List<dynamic> row = [];
          row.add(name[i]);
          row.add(description[i]);
          row.add(brand[i]);
          row.add(category[i]);
          row.add(varietyname[i]);
          row.add(varietyprice[i]);
          row.add(varietywsp[i]);
          row.add(rank[i]);
          row.add(imagefilename[i]);
          rows.add(row);
        }
      }

      Widget _errorondownload(BuildContext context) {
        return AlertDialog(
          title: Text('Error Downloading'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Can\'t able to download in Download Directory '
                  '\nClick below to save CSV to App Directory'),
              SizedBox(height: 7),
              // ignore: deprecated_member_use
              RaisedButton(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text('Save CSV in App Directory',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white)),
                ),
                onPressed: () {
                  Navigator.of(context).pop('saved');
                },
              ),
            ],
          ),
        );
      }

      try {
        if (await Permission.storage.request().isGranted) {
          var dir = await ExternalPath.getExternalStoragePublicDirectory(
              ExternalPath.DIRECTORY_DOWNLOADS);
          Directory imagedir =
              await Directory('$dir/Product E-catalogue/Exported Data')
                  .create(recursive: true);
          File f = await new File("${imagedir.path}/ProductData.csv")
              .create(recursive: true);
          var isExist = await f.exists();
          if (isExist) {
            String csv = const ListToCsvConverter().convert(rows);
            snackBar = SnackBar(
                content: Text(
                    'Data Exported Succesfully to Product E-catalogue folder..!'));
            _scaffoldkey.currentState!.showSnackBar(snackBar);
            return f.writeAsString(csv);
          }
        }
      } catch (e) {
        print(e);
        try {
          // print('ddd');
          Directory appDir =
              await (pPath.getExternalStorageDirectory() as Future<Directory>);
          Directory csvdir = await Directory('${appDir.path}/ProductDataCSV')
              .create(recursive: true);
          print(csvdir);
          File file = await new File("${csvdir.path}/ProductData.csv")
              .create(recursive: true);
          String? output = await showDialog(
              context: context,
              builder: (BuildContext context) => _errorondownload(context));
          bool isExist = await file.exists();
          if (output == 'saved') {
            if (isExist) {
              String csv = const ListToCsvConverter().convert(rows);
              snackBar =
                  SnackBar(content: Text('CSV exported to App Directory..!'));
              _scaffoldkey.currentState!.showSnackBar(snackBar);
              return file.writeAsString(csv);
            } else {
              snackBar =
                  SnackBar(content: Text('Sorry, Error in Exporting Data..!'));
            }
          } else {
            snackBar = SnackBar(content: Text('Sorry, Error -> $e'));
          }
          print(snackBar);
        } catch (ee) {
          print('>>> $ee');
          snackBar = SnackBar(content: Text('Sorry, Error -> $ee'));
        }
        print(snackBar);
        _scaffoldkey.currentState!.showSnackBar(snackBar);
      }
    }

    return Scaffold(
      key: _scaffoldkey,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Import Export Data'),
      ),
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
