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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize();
  runApp(HomePage());
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)),
        builder: (c, s) => s.connectionState != ConnectionState.done
            ? LoadingScreen()
            : ProductCatalogue());
  }
}

class ProductCatalogue extends StatefulWidget {
  static const routeName = '/ProductCatalogue';
  const ProductCatalogue({Key key}) : super(key: key);

  @override
  _ProductCatalogueState createState() => _ProductCatalogueState();
}

class _ProductCatalogueState extends State<ProductCatalogue> {
  SecureStorage storage = SecureStorage();
  String loginstatus;


  @override
  void initState() {
    loginstate();
    super.initState();
  }

  void loginstate() async {
    loginstatus = await storage.getloginstatus();
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
            // FirebaseUser user = snapshot.data; // this is your user instance
            return Tabscreenwithdata();
          } else {
            if (loginstatus == 'Skiped_login') {
              return Tabscreenwithdata();
            } else {
              // other way there is no user logged.
              return LoginPage();
            }
          }
        },
      );
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProductData()),
        ChangeNotifierProvider.value(value: CategoryData()),
        ChangeNotifierProvider.value(value: VarietyData()),
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
          // Tabscreenwithdata
        },
      ),
    );
  }
}

//C:\Program Files\Android\Android Studio\jre\bin\java
// E/flutter (19456): [ERROR:flutter/lib/ui/ui_dart_state.cc(166)] Unhandled Exception:
// FileSystemException: Creation failed, path = '/storage/emulated/0/Download/ProductE-Catalogue'
// (OS Error: Permission denied, errno = 13)
