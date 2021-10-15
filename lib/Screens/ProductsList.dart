import 'package:flutter/material.dart';
import 'package:productcatalogue/Provider/CategoryDataP.dart';
import '../Widgets/ProductListBox.dart';
import '../Models/ProductModel.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';
import '../Tool/FilterProduct.dart';
import '../Provider/VarietyDataP.dart';
import '../Screens/Import.dart';
import '../contact/Aboutus.dart';
import '../Screens/UserAEFrom.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// import 'package:flutter_native_admob/native_admob_options.dart';
// import 'dart:async';
// import 'package:flutter_native_admob/flutter_native_admob.dart' as ad;
// import 'package:flutter_native_admob/native_admob_controller.dart';

class ProductsList extends StatefulWidget {
  static const routeName = '/productlist';
  ProductsList();
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  TextEditingController controller = new TextEditingController();
  String? filter;
  Filtertool filtertool = Filtertool();
  List<ProductModel>? filteredlist;
  List<ProductModel?>? productlist;
  List<ProductModel?>? allproductlist;
  late Function findcategorynamebyid;
  Filterdata? filterdata;
  List<String> brandlist = [];
  Function? varietyrangefunc;
  bool issortname = false;
  bool issortprice = false;
  bool issortrank = false;
  // final _nativeAdmob = NativeAdmob();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // _subscription.cancel();
    super.dispose();
  }

// ca-app-pub-9568938816087708~5406343573
  // static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  // double _height = 0;
  // late StreamSubscription _subscription;
  // static const _adUnitID = "ca-app-pub-3940256099942544/2247696110";
  //-> native sample

  @override
  void didChangeDependencies() {
    findcategorynamebyid =
        Provider.of<CategoryData>(context).findcategorynamebyid;
    varietyrangefunc = Provider.of<VarietyData>(context).minmaxvalue;
    allproductlist = Provider.of<ProductData>(context).items;
    filterdata = filterdata ??
        Filterdata(brandlist: null, categorylist: null, rangeofprice: null);
    productlist = filtertool.filteredproduct(
        allproductlist, filterdata!, varietyrangefunc);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant ProductsList oldWidget) {
    allproductlist = Provider.of<ProductData>(context).items;
    filterdata = filterdata ??
        Filterdata(brandlist: null, categorylist: null, rangeofprice: null);
    super.didUpdateWidget(oldWidget);
  }

  bool? issort;
  @override
  Widget build(BuildContext context) {
    productlist = filtertool.filteredproduct(
        allproductlist, filterdata!, varietyrangefunc);
    void sortbyname(List<ProductModel?> list) {
      list
        ..sort((a, b) => issortname
            ? (b!.name?.toLowerCase() ?? '')
                .compareTo((a!.name?.toLowerCase() ?? ''))
            : (a!.name?.toLowerCase() ?? '')
                .compareTo((b!.name?.toLowerCase() ?? '')));
      issortname = !issortname;
      setState(() {});
    }

    void sortbyprice(List<ProductModel?> list) {
      list
        ..sort((a, b) => issortprice
            ? varietyrangefunc!(b!.id)[0].compareTo(varietyrangefunc!(a!.id)[0])
            : varietyrangefunc!(a!.id)[1]
                .compareTo(varietyrangefunc!(b!.id)[1]));
      issortprice = !issortprice;
      setState(() {});
    }

    void sortbyrank(List<ProductModel?> list) {
      list
        ..sort((a, b) => issortrank
            ? b!.rank!.compareTo(a!.rank!)
            : a!.rank!.compareTo(b!.rank!));
      issortrank = !issortrank;
      setState(() {});
    }

    void sortbottomsheet(
        BuildContext context, List<ProductModel?>? productlist) {
      showModalBottomSheet(
          context: context,
          builder: (_) {
            return Container(
              child: Column(
                children: <Widget>[
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.sort_by_alpha),
                      title: issortname
                          ? Text('By Name Z-A')
                          : Text('By Name A-Z'),
                      onTap: () {
                        Navigator.pop(context);
                        sortbyname(productlist!);
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.format_list_numbered),
                      title: issortprice
                          ? Text('Price High To Low')
                          : Text('Price: Low to High'),
                      onTap: () {
                        Navigator.pop(context);
                        sortbyprice(productlist!);
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(Icons.confirmation_number),
                      title: issortrank
                          ? Text('Rank: High To Low')
                          : Text('Rank: Low to High'),
                      onTap: () {
                        Navigator.pop(context);
                        sortbyrank(productlist!);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
          elevation: 5);
    }

    Widget filterchip() {
      if ((filterdata?.brandlist == null || filterdata?.brandlist == []) &&
          (filterdata?.categorylist == null ||
              filterdata?.categorylist == []) &&
          filterdata?.rangeofprice == null) {
        return SizedBox(height: 1);
      } else {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                filterdata?.rangeofprice == null
                    ? SizedBox(width: 2)
                    : Container(
                        height: 30,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1),
                        child: FilterChip(
                            label: Text(
                              'Price Range ${filterdata!.rangeofprice!.start} - ${filterdata!.rangeofprice!.end}',
                              style: TextStyle(fontSize: 12),
                            ),
                            avatar: Icon(Icons.cancel, size: 15),
                            onSelected: (_) {
                              filterdata = Filterdata(
                                  brandlist: filterdata?.brandlist,
                                  categorylist: filterdata?.categorylist,
                                  rangeofprice: null);
                              productlist = filtertool.filteredproduct(
                                  allproductlist,
                                  filterdata!,
                                  varietyrangefunc);
                              setState(() {});
                            }),
                      ),
                (filterdata!.brandlist == null)
                    ? SizedBox(width: 2)
                    : Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(1),
                        height: 30,
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: FilterChip(
                                  label: Text('${filterdata!.brandlist![idx]}',
                                      style: TextStyle(fontSize: 12)),
                                  avatar: Icon(Icons.cancel, size: 15),
                                  onSelected: (_) {
                                    setState(() {
                                      filterdata!.brandlist!.removeAt(idx);
                                      filterdata = Filterdata(
                                          brandlist:
                                              (filterdata!.brandlist!.length ==
                                                      0)
                                                  ? null
                                                  : filterdata?.brandlist,
                                          categorylist:
                                              filterdata?.categorylist,
                                          rangeofprice:
                                              filterdata?.rangeofprice);
                                      productlist = filtertool.filteredproduct(
                                          allproductlist,
                                          filterdata!,
                                          varietyrangefunc);
                                    });
                                  }),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: filterdata!.brandlist!.length,
                        ),
                      ),
                (filterdata!.categorylist == null)
                    ? SizedBox(width: 2)
                    : Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: FilterChip(
                                  label: Text(
                                      '${findcategorynamebyid(filterdata!.categorylist![idx])}',
                                      style: TextStyle(fontSize: 12)),
                                  avatar: Icon(Icons.cancel, size: 15),
                                  onSelected: (_) {
                                    setState(() {
                                      filterdata!.categorylist!.removeAt(idx);
                                      filterdata = Filterdata(
                                          brandlist: filterdata?.brandlist,
                                          categorylist: (filterdata!
                                                      .categorylist!.length ==
                                                  0)
                                              ? null
                                              : filterdata?.categorylist,
                                          rangeofprice:
                                              filterdata?.rangeofprice);
                                      productlist = filtertool.filteredproduct(
                                          allproductlist,
                                          filterdata!,
                                          varietyrangefunc);
                                    });
                                  }),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: filterdata!.categorylist!.length,
                        ),
                      )
              ],
            ),
          ),
        );
      }
    }

    if (productlist == null) productlist = [];
    List<int> ints = List<int>.generate(5, (i) => i * 7);
    ints.remove(0);
    productlist = productlist!
        .where((e) => (e!.name?.toLowerCase() ?? '')
            .contains(filter?.toLowerCase() ?? ''))
        .toList();
    return (allproductlist == null)
        ? CircularProgressIndicator()
        : (allproductlist!.length == 0)
            ? NoItems()
            : Column(
                children: <Widget>[
                  filterchip(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.sort),
                          onPressed: () {
                            setState(() {
                              sortbottomsheet(context, allproductlist);
                            });
                          }),
                      SizedBox(width: 5),
                      Expanded(
                        child: Container(
                          height: 40,
                          child: TextField(
                            decoration: new InputDecoration(
                                prefixIcon: Icon(Icons.search),
                                labelText: "Search Product",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            controller: controller,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      IconButton(
                          color: Colors.black,
                          icon: Icon(Icons.filter_list),
                          onPressed: () async {
                            Filterdata? fdata = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) =>
                                        FilterProduct(filterdata: filterdata)));
                            if (fdata != null) {
                              filterdata = fdata;
                              productlist = filtertool.filteredproduct(
                                  allproductlist,
                                  filterdata!,
                                  varietyrangefunc);
                              setState(() {});
                            }
                          })
                    ],
                  ),
                  (productlist!.length == 0)
                      ? Center(
                          child: Text('No Product Available At your Filter',
                              textAlign: TextAlign.center))
                      : Flexible(
                          child: Container(
                            child: ListView.builder(
                                itemBuilder: (ctx, index) {
                                  return ProductListBox(
                                      product: productlist![index]);
                                },
                                itemCount: productlist!.length,
                                shrinkWrap: true),
                          ),
                        )
                ],
              );
  }

  // List<ProductModel> searchbox(List<ProductModel> product, String keyword) {
  //   if (keyword.trim() == '') {
  //     return product;
  //   } else {
  //     return product;
  //   }
  // }
}

class NoItems extends StatelessWidget {
  const NoItems({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset('assets/emptybox.png'),
            width: 150,
          ),
          Text('No Product Added Yet', textAlign: TextAlign.center),
          SizedBox(height: 2),
          Text('Start Adding Something OR Import Product Data',
              textAlign: TextAlign.center),
          Container(
            padding: EdgeInsets.all(10),
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 7,
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Add Product',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, UserAEForm.routeName);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 7,
              color: Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Import Bulk Product',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, ImportExport.routeName);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 2, 10, 10),
            // ignore: deprecated_member_use
            child: RaisedButton(
              elevation: 7,
              color: Colors.blueAccent,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'About App',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AboutUs.routeName);
              },
            ),
          )
        ],
      ),
    );
  }
}
