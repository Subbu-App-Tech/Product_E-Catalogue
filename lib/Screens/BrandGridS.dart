import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/GridW.dart';
import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:async';
import 'package:flutter_native_admob/flutter_native_admob.dart' as ad;
import 'package:flutter_native_admob/native_admob_controller.dart';
import '../Models/CategoryModel.dart';

class BrandListS extends StatefulWidget {
  const BrandListS({Key key}) : super(key: key);
  static const routeName = '/brandlist_screen';

  @override
  _BrandListSState createState() => _BrandListSState();
}

class _BrandListSState extends State<BrandListS> {
  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    _nativeAdController.setAdUnitID(_adUnitID, numberAds: 2);
    // _nativeAdController.setTestDeviceIds([
    //   '400A0E6F669C5ECA',
    //   '33BE2250B43518CCDA7DE426D04EE231',
    //   '70986832EA2D276F6277A5461962A4EC'
    // ]);
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

// ca-app-pub-9568938816087708~5406343573
  static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  // static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  //-> native sample
  final _nativeAdController = NativeAdmobController();
  double _height = 0;
  double _height2 = 0;
  StreamSubscription _subscription;

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          _height = 0;
          _height2 = 0;
        });
        break;
      case AdLoadState.loadCompleted:
        setState(() {
          _height = 140;
          _height2 = 60;
        });
        break;
      default:
        break;
    }
  }

  Widget adwidget(bool ished) {
    return Card(
      child: Container(
        height: ished ? _height2 : _height,
        padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: ad.NativeAdmob(
            adUnitID: _adUnitID,
            error: Text('Error'),
            numberAds: 2,
            type: ished ? ad.NativeAdmobType.banner : ad.NativeAdmobType.full,
            controller: _nativeAdController,
            options: NativeAdmobOptions(
                priceTextStyle:
                    NativeTextStyle(fontSize: 15, color: Colors.red),
                bodyTextStyle:
                    NativeTextStyle(fontSize: 14, color: Colors.black)),
            loading: Text('Loading')),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Brandcount> branddata = Provider.of<ProductData>(context).uqbrand();
    // final productlist =
    //     Provider.of<ProductData>(context).productlistbybrandname;
    branddata = [...branddata, ...branddata];
    return (branddata.length == 0)
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                adwidget(true),
                Container(
                  child: Image.asset('assets/emptybox.png'),
                  width: 150,
                ),
                Text('No Product Available Yet'),
                SizedBox(height: 2),
                Text('Start Adding Something OR Import Product Data',
                    textAlign: TextAlign.center),
                adwidget(false)
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                adwidget(true),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    value: branddata[index],
                    child: GridViewW(
                      title: branddata[index].name,
                      count: branddata[index].count,
                      brand: branddata[index].name,
                      // productlist: productlist(branddata[index].name),
                    ),
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: branddata.length,
                ),
                adwidget(false)
              ],
            ),
          );
  }
}
