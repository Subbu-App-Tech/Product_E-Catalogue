import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/GridW.dart';
import 'dart:async';
import '../Models/CategoryModel.dart';

class BrandListS extends StatefulWidget {
  const BrandListS({Key? key}) : super(key: key);
  static const routeName = '/brandlist_screen';

  @override
  _BrandListSState createState() => _BrandListSState();
}

class _BrandListSState extends State<BrandListS> {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  late StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    List<Brandcount> branddata = Provider.of<ProductData>(context).uqbrand();
    return (branddata.length == 0)
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // adwidget(true),
                Container(
                  child: Image.asset('assets/emptybox.png'),
                  width: 150,
                ),
                Text('No Product Available Yet'),
                SizedBox(height: 2),
                Text('Start Adding Something OR Import Product Data',
                    textAlign: TextAlign.center),
                // adwidget(false)
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                // adwidget(true),
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
                // adwidget(false)
              ],
            ),
          );
  }
}
