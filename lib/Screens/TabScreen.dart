import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/ProductModel.dart';
import '../Screens/ProductsList.dart';
import '../Screens/CategoryGridS.dart';
import '../Screens/BrandGridS.dart';
import '../Screens/UserAEFrom.dart';
import '../Screens/FavproductList.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/Drawer.dart';
import '../Provider/CategoryDataP.dart';
import '../Provider/VarietyDataP.dart';
import '../Tool/FilterProduct.dart';
import 'package:rate_my_app/rate_my_app.dart';
import '../contact/Contactus.dart';

class Tabscreenwithdata extends StatelessWidget {
  static const routeName = '/Tabscreenwithdata';

  const Tabscreenwithdata({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabScreen();
  }
}

class TabScreen extends StatefulWidget {
  final Filterdata filterdata;
  TabScreen({this.filterdata});

  @override
  _TabScreenState createState() => _TabScreenState();
}

class _TabScreenState extends State<TabScreen> {
  List<Map<String, Object>> _pages;
  int _selectedPageIndex = 0;
  List<ProductModel> favproducts;
  var _isInit = true;
  var _isLoading = false;
  RateMyApp _rateMyApp = RateMyApp(
      preferencesPrefix: 'Rate My APP',
      googlePlayIdentifier: 'com.subbu.productcatalogue',
      appStoreIdentifier: 'com.subbu.productcatalogue',
      //'product-catalogue-app-f7bf8',
      minDays: 3,
      minLaunches: 7,
      remindDays: 2,
      remindLaunches: 11);
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _rateMyApp.init().then((_) {
        if (_rateMyApp.shouldOpenDialog) {
          _rateMyApp.showStarRateDialog(
            context,
            title: 'Rate this App',
            message:
                'If you like this app, please take a little bit of your time to review it !'
                ''
                'It really helps us and it shouldn\'t take you more than one minute.',
            actionsBuilder: (_, stars) {
              return [
                FlatButton(
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
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      fetchdata().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    favproducts = Provider.of<ProductData>(context).favoriteItems;
    _pages = [
      {'page': ProductsList(), 'title': 'Products'},
      {'page': CategoryGridS(), 'title': 'Categories'},
      {'page': BrandListS(), 'title': 'Brands'},
    ];
    super.didChangeDependencies();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Future fetchdata() async {
    await Provider.of<ProductData>(context, listen: false).fetchproduct();
    await Provider.of<CategoryData>(context, listen: false).fetchcategory();
    return Provider.of<VarietyData>(context, listen: false).fetchvariety();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.shopping_bag),
              onPressed: () {
                Navigator.pushNamed(context, ContactUs.routeName,
                    arguments: true);
              }),
          Container(
            child: Stack(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Icon(Icons.favorite, size: 27),
                    onPressed: () {
                      Navigator.pushNamed(context, FavProductsList.routeName);
                    },
                  ),
                ),
                (favproducts.length == 0)
                    ? SizedBox.shrink()
                    : Positioned(
                        right: 3,
                        top: 5,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            '${favproducts.length}',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      )
              ],
            ),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _pages[_selectedPageIndex]['page'],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(UserAEForm.routeName);
        },
        child: Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.apps), label: ('Product')),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: ('Category')),
          BottomNavigationBarItem(
              icon: Icon(Icons.branding_watermark), label: ('Brand')),
        ],
        showSelectedLabels: true,
        elevation: 7,
        currentIndex: _selectedPageIndex,
      ),
      // ),
      // routes: {
      //   AddVariety.routeName: (ctx) => AddVariety(),
      //   CategoryGridS.routeName: (ctx) => CategoryGridS(),
      //   BrandListS.routeName: (ctx) => BrandListS(),
      //   FavProductsList.routeName: (ctx) => FavProductsList(),
      //   ImportExport.routeName: (ctx) => ImportExport(),
      //   FilterProduct.routeName: (ctx) => FilterProduct(),
      //   UserAEForm.routeName: (ctx) => UserAEForm(),
      //   ExportData.routeName: (ctx) => ExportData(),
      //   SettingScreen.routeName: (ctx) => SettingScreen(),
      //   ContactUs.routeName: (ctx) => ContactUs(),
      //   AboutUs.routeName: (ctx) => AboutUs()
      // },
    );
  }
}
