import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Provider/CategoryDataP.dart';
import 'Provider/ProductDataP.dart';
import 'Provider/VarietyDataP.dart';
import 'Screens/UserAEFrom.dart';
import 'Widgets/Addvariety.dart';
import 'Screens/CategoryGridS.dart';
import 'Screens/BrandGridS.dart';
import 'Screens/FavproductList.dart';
import 'Screens/TabScreen.dart';
import 'Screens/Import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'Screens/loginscreen.dart';
import 'Tool/FilterProduct.dart';
import 'Screens/Export.dart';
import 'Screens/Settingscreen.dart';
import 'Models/SecureStorage.dart';
import 'contact/Aboutus.dart';
import 'contact/Contactus.dart';
import 'contact/loadingscreen.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'Screens/FilteredProductList.dart';
import 'Models/ProductModel.dart';
import 'Models/VarietyProductModel.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_core/firebase_core.dart' as fs;
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'Models/CategoryModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  Box<ProductModel> pbox;
  Box<VarietyProductM> vbox;
  Box<CategoryModel> cbox;
  Directory dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);
  if (!(Hive.isAdapterRegistered(0))) {
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(VarietyProductMAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
  }
  pbox = await Hive.openBox<ProductModel>('ProductModel');
  vbox = await Hive.openBox<VarietyProductM>('VarietyProductM');
  cbox = await Hive.openBox<CategoryModel>('CategoryModel');
  runApp(HomePage(cbox: cbox, pbox: pbox, vbox: vbox));
}

class HomePage extends StatelessWidget {
  final Box<ProductModel> pbox;
  final Box<VarietyProductM> vbox;
  final Box<CategoryModel> cbox;

  HomePage({this.pbox, this.vbox, this.cbox});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (c, s) => s.connectionState != ConnectionState.done
            ? LoadingScreen()
            : ProductCatalogue(cbox: cbox, pbox: pbox, vbox: vbox));
  }
}

class ProductCatalogue extends StatefulWidget {
  final Box<ProductModel> pbox;
  final Box<VarietyProductM> vbox;
  final Box<CategoryModel> cbox;
  static const routeName = '/ProductCatalogue';
  const ProductCatalogue({Key key, this.pbox, this.vbox, this.cbox})
      : super(key: key);

  @override
  _ProductCatalogueState createState() => _ProductCatalogueState();
}

class _ProductCatalogueState extends State<ProductCatalogue> {
  SecureStorage storage = SecureStorage();
  String loginstatus;
  Box<ProductModel> pbox;
  Box<VarietyProductM> vbox;
  Box<CategoryModel> cbox;

  @override
  void initState() {
    loginstate();
    super.initState();
  }

  void loginstate() async {
    loginstatus = await storage.getloginstatus();
  }

  Future future() async {
    pbox = widget.pbox ?? Hive.box<ProductModel>('ProductModel');
    vbox = widget.vbox ?? Hive.box<VarietyProductM>('VarietyProductM');
    cbox = widget.cbox ?? Hive.box<CategoryModel>('CategoryModel');
  }

  @override
  Widget build(BuildContext context) {
    Widget homescreen() {
      return FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            return Tabscreenwithdata();
          } else {
            if (loginstatus == 'Skiped_login') {
              return Tabscreenwithdata();
            } else {
              return LoginPage();
            }
          }
        },
      );
    }

    Widget setboxes() {
      return FutureBuilder(
        future: future(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: ProductData(pbox)),
                ChangeNotifierProvider.value(value: CategoryData(cbox)),
                ChangeNotifierProvider.value(value: VarietyData(vbox)),
                ChangeNotifierProvider.value(value: SecureStorage())
              ],
              child: MaterialApp(
                home: homescreen(),
                routes: {
                  AddVariety.routeName: (ctx) => AddVariety(),
                  CategoryGridS.routeName: (ctx) => CategoryGridS(),
                  BrandListS.routeName: (ctx) => BrandListS(),
                  FavProductsList.routeName: (ctx) => FavProductsList(),
                  ImportExport.routeName: (ctx) => ImportExport(),
                  FilterProduct.routeName: (ctx) => FilterProduct(),
                  UserAEForm.routeName: (ctx) => UserAEForm(),
                  ExportData.routeName: (ctx) => ExportData(),
                  SettingScreen.routeName: (ctx) => SettingScreen(),
                  ContactUs.routeName: (ctx) => ContactUs(),
                  AboutUs.routeName: (ctx) => AboutUs(),
                  Tabscreenwithdata.routeName: (ctx) => Tabscreenwithdata(),
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      );
    }

    return setboxes();
  }
}

//C:\Program Files\Android\Android Studio\jre\bin\java
// E/flutter (19456): [ERROR:flutter/lib/ui/ui_dart_state.cc(166)] Unhandled Exception:
// FileSystemException: Creation failed, path = '/storage/emulated/0/Download/ProductE-Catalogue'
// (OS Error: Permission denied, errno = 13)
