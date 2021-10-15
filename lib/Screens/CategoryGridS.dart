import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Widgets/GridW.dart';
import '../Provider/ProductDataP.dart';
import '../Provider/CategoryDataP.dart';
// import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:async';
// import 'package:flutter_native_admob/flutter_native_admob.dart' as ad;
// import 'package:flutter_native_admob/native_admob_controller.dart';

// import '../Models/CategoryModel.dart';

class CategoryGridS extends StatefulWidget {
  CategoryGridS({Key? key}) : super(key: key);
  static const routeName = '/catgrid';

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
    _subscription.cancel();
    // _nativeAdController.dispose();
    super.dispose();
  }

// ca-app-pub-9568938816087708~5406343573
  // static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  // static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  //-> native sample
  // final _nativeAdController = NativeAdmobController();
  // double _height = 0;
  // double _height2 = 0;
  late StreamSubscription _subscription;

  // void _onStateChanged(AdLoadState state) {
  //   switch (state) {
  //     case AdLoadState.loading:
  //       setState(() {
  //         _height = 0;
  //         _height2 = 0;
  //       });
  //       break;
  //     case AdLoadState.loadCompleted:
  //       setState(() {
  //         _height = 140;
  //         _height2 = 60;
  //       });
  //       break;
  //     default:
  //       break;
  //   }
  // }

  // Widget adwidget(bool isone) {
  //   return Card(
  //     child: Container(
  //       height: (isone) ? _height : _height2,
  //       padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
  //       child: ad.NativeAdmob(
  //           adUnitID: _adUnitID,
  //           error: Text('Error'),
  //           numberAds: 2,
  //           type: (isone) ? ad.NativeAdmobType.full : ad.NativeAdmobType.banner,
  //           controller: _nativeAdController,
  //           options: NativeAdmobOptions(
  //               priceTextStyle:
  //                   NativeTextStyle(fontSize: 15, color: Colors.red),
  //               bodyTextStyle:
  //                   NativeTextStyle(fontSize: 14, color: Colors.black)),
  //           loading: Text('Loading')),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final catdata = Provider.of<ProductData>(context).categorycountlist();
    List uqcatid = Provider.of<ProductData>(context).uqcatidlist();
    final catname = Provider.of<CategoryData>(context).items;
    Function findcatname =
        Provider.of<CategoryData>(context).findcategorynamebyid;
    List catids = Provider.of<CategoryData>(context).itemid();
    List emptycatid = [];
    List emptycatname = [];
    for (String? i in catids as Iterable<String?>) {
      if (!uqcatid.contains(i)) {
        emptycatid.add(i);
        emptycatname.add(findcatname(i));
      } else {}
    }
    // final productlist = Provider.of<ProductData>(context).productlistbycatid;
    List<String?> catnamelist = [];
    if (catdata.length != 0) {
      for (var i in catdata) {
        if (i.id == 'otherid') {
          catnamelist.add('Other');
        } else {
          catnamelist.add(catname.firstWhere((f) => f.id == i.id).name);
        }
      }
    }

    void deletecat(String? catidval) {
      emptycatname = List.from(emptycatname)
        ..firstWhere((e) => e == findcatname(catidval));
      emptycatid = List.from(emptycatid)..firstWhere((e) => e == catidval);
      Provider.of<CategoryData>(context, listen: false).delete(catidval);
      setState(() {});
    }

    // List<int> ints = List<int>.generate(25, (i) => i * 6);
    // ints.remove(0);
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
                  itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
                    value: catdata[index],
                    child: GridViewW(
                      title: catnamelist[index],
                      count: catdata[index].count,
                      catid: catdata[index].id,
                    ),
                  ),
                  itemCount: catdata.length,
                  physics: NeverScrollableScrollPhysics(),
                ),
                SizedBox(height: 10),
                (emptycatid.length == 0)
                    ? SizedBox.shrink()
                    : Column(
                        children: [
                          // adwidget(false),
                          SizedBox(height: 10),
                          Container(
                            padding: EdgeInsets.all(5),
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: Text(
                              'Category With 0 Items',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Divider(),
                          GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 3 / 2,
                                    crossAxisSpacing: 2,
                                    mainAxisSpacing: 2),
                            itemBuilder: (ctx, index) => GridViewW(
                              title: emptycatname[index],
                              count: 0,
                              delete: () => deletecat(emptycatid[index]),
                            ),
                            itemCount: emptycatname.length,
                            physics: NeverScrollableScrollPhysics(),
                          ),
                        ],
                      ),
                // adwidget(true),
              ],
            ),
          );
  }
}
