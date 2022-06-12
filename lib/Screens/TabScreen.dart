import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:productcatalogue/main.dart';
import '../Screens/ProductsList.dart';
import '../Screens/CategoryGridS.dart';
import '../Screens/BrandGridS.dart';
import 'Form/product_form.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/Drawer.dart';
import '../Tool/FilterProduct.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../contact/Contactus.dart';
import 'package:badges/badges.dart';

class Tabscreenwithdata extends StatelessWidget {
  static const routeName = '/Tabscreenwithdata';

  const Tabscreenwithdata({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScreen();
  }
}

class TabScreen extends StatefulWidget {
  final Filterdata? filterdata;
  TabScreen({this.filterdata});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  late List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  late List<Product?> favproducts;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      MyAppFunc(context).rateMyApp();
    });
    favproducts = Provider.of<ProductData>(context).favoriteItems;
    _pages = [
      {'page': ProductsList(), 'title': 'Products'},
      {'page': CategoryGridS(), 'title': 'Categories'},
      {'page': BrandListS(), 'title': 'Brands'},
    ];
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() => _selectedPageIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Scaffold(
              drawer: MyDrawer(),
              appBar: AppBar(
                title: Text(_pages[_selectedPageIndex]['title'] as String),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.shopping_bag),
                      onPressed: () {
                        Navigator.pushNamed(context, ContactUs.routeName,
                            arguments: true);
                      }),
                  SizedBox(width: 5),
                  Badge(
                    child: IconButton(
                      icon: Icon(Icons.favorite, size: 27),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ProductsList(isFavOnly: true),
                            ));
                        // Navigator.pushNamed(context, FavProductsList.routeName);
                      },
                    ),
                    badgeContent: Text('${favproducts.length}'),
                    showBadge: favproducts.length > 0,
                  ),
                ],
              ),
              body: _pages[_selectedPageIndex]['page'] as Widget,
              floatingActionButton: appSetting.isViewMode
                  ? SizedBox()
                  : FloatingActionButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(UserAEForm.routeName),
                      child: Icon(Icons.add)),
              bottomNavigationBar: BottomNavigationBar(
                  onTap: _selectPage,
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.apps), label: ('Product')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.category), label: ('Category')),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.branding_watermark), label: ('Brand')),
                  ],
                  showSelectedLabels: true,
                  elevation: 7,
                  currentIndex: _selectedPageIndex),
            ),
          ),
        ],
      ),
    );
  }
}

class MyAppFunc {
  BuildContext context;
  MyAppFunc(this.context);
  RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'Rate My APP',
      googlePlayIdentifier: 'com.subbu.productcatalogue',
      appStoreIdentifier: 'com.subbu.productcatalogue',
      //'product-catalogue-app-f7bf8',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 11);

  void rateMyApp() {
    _rateMyApp.init().then((_) {
      if (_rateMyApp.shouldOpenDialog) {
        _rateMyApp.showStarRateDialog(
          context,
          title: 'Rate this App',
          message:
              'If you like this app, Please take a little bit of your time to review it !'
              ''
              'It really helps us and it shouldn\'t take you more than one minute.',
          actionsBuilder: (_, stars) {
            return [
              TextButton(
                child: Text('OK'),
                onPressed: () async {
                  if (stars != null && (stars > 2)) {
                    await _rateMyApp
                        .callEvent(RateMyAppEventType.rateButtonPressed);
                    Navigator.pop<RateMyAppDialogButton>(
                        context, RateMyAppDialogButton.rate);
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ];
          },
          dialogStyle: DialogStyle(
              titleAlign: TextAlign.center,
              messageAlign: TextAlign.center,
              messagePadding: EdgeInsets.only(bottom: 20.0)),
          starRatingOptions: StarRatingOptions(),
          onDismissed: () =>
              _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        );
      }
    });
  }
}
