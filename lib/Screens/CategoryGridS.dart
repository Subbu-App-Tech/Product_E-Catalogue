import 'package:flutter/material.dart';
import '../Widgets/GridW.dart';
import '../Provider/ProductDataP.dart';
import 'dart:async';

class CategoryGridS extends StatefulWidget {
  CategoryGridS({Key? key}) : super(key: key);
  static const routeName = '/catgId';

  @override
  _CategoryGridSState createState() => _CategoryGridSState();
}

class _CategoryGridSState extends State<CategoryGridS> {
  @override
  void initState() {
    // _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    // _nativeAdController.setAdUnitID(_adUnitID, numberAds: 2);
    // _nativeAdController.setTestDeviceIds([
    //   '400A0E6F669C5ECA',
    //   '33BE2250B43518CCDA7DE426D04EE231',
    //   '70986832EA2D276F6277A5461962A4EC'
    // ]);
    super.initState();
  }

  @override
  void dispose() {
    // _subscription.cancel();
    // _nativeAdController.dispose();
    super.dispose();
  }

  // ca-app-pub-9568938816087708~5406343573
  // static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  // static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  //-> native sample
  late StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    final catdata = Provider.of<ProductData>(context).categCountList;
    return (catdata.length == 0)
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // adwidget(false),
                Container(
                    child: Image.asset('assets/emptybox.png'), width: 150),
                Text('No Product Available Yet'),
                SizedBox(height: 2),
                Text('Start Adding Something OR Import Product Data',
                    textAlign: TextAlign.center),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // adwidget(false),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (ctx, index) => GridViewW(
                      count: catdata[index].count,
                      name: catdata[index].name ?? ' -N- ',
                      isCateg: true),
                  itemCount: catdata.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
  }
}
