import 'package:flutter/material.dart';
import 'Provider/ProductDataP.dart';
import 'Screens/Form/product_form.dart';
import 'Screens/CategoryGridS.dart';
import 'Screens/BrandGridS.dart';
import 'Screens/TabScreen.dart';
import 'Screens/Import.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'Screens/loginscreen.dart';
import 'Tool/FilterProduct.dart';
import 'Screens/Export.dart';
import 'Screens/Settingscreen.dart';
import 'contact/Aboutus.dart';
import 'contact/Contactus.dart';
import 'contact/loadingscreen.dart';
import 'export.dart';

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
  const ProductCatalogue({Key? key}) : super(key: key);

  @override
  _ProductCatalogueState createState() => _ProductCatalogueState();
}

class _ProductCatalogueState extends State<ProductCatalogue> {
  String? loginstatus;

  Future<User?> getData() async {
    loginstatus = await storage.getloginstatus();
    return fa.FirebaseAuth.instance.currentUser;
  }

  Widget get homeScreen {
    return FutureBuilder<User?>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ProductData()),
      ],
      child: MaterialApp(
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        home: homeScreen,
        routes: {
          CategoryGridS.routeName: (ctx) => CategoryGridS(),
          BrandListS.routeName: (ctx) => BrandListS(),
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
  }
}
