import 'package:flutter/material.dart';
import '../Models/ProductModel.dart';
import '../Widgets/ProductListBox.dart';
import '../Screens/UserAEFrom.dart';
import '../Provider/VarietyDataP.dart';
import '../Provider/ProductDataP.dart';
import 'package:provider/provider.dart';
// import 'package:flutter_native_admob/native_admob_options.dart';
import 'dart:async';
// import 'package:flutter_native_admob/flutter_native_admob.dart' as ad;
// import 'package:flutter_native_admob/native_admob_controller.dart';

class FilteredProductsList extends StatefulWidget {
  // final List<ProductModel> productlist;
  final String? catid;
  final String? brand;
  // String type;
  final String? title;
  final VoidCallback? togfav;
  FilteredProductsList({this.title, this.togfav, this.brand, this.catid});

  @override
  _FilteredProductsListState createState() => _FilteredProductsListState();
}

class _FilteredProductsListState extends State<FilteredProductsList> {
  TextEditingController controller = new TextEditingController();
  List<ProductModel?> productlist = [];
  List<ProductModel?> allproductlist = [];
  late Function varietypricerange;
  bool issortname = false;
  String? filter;
  bool issortprice = false;
  bool issortrank = false;
  // int _sortby;
  // bool acc;
  @override
  void initState() {
    // setState(() {});
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
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
    controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (widget.catid != null) {
      allproductlist =
          Provider.of<ProductData>(context).productlistbycatid(widget.catid);
    } else if (widget.brand != null) {
      allproductlist =
          Provider.of<ProductData>(context).findbybrand(widget.brand);
    }
    varietypricerange = Provider.of<VarietyData>(context).minmaxvalue;
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    productlist = [...allproductlist];
    void sortbyname(List<ProductModel?> list) {
      list
        ..sort((a, b) => issortname
            ? b!.name!.toLowerCase().compareTo(a!.name!.toLowerCase())
            : a!.name!.toLowerCase().compareTo(b!.name!.toLowerCase()));
      issortname = !issortname;
      setState(() {});
    }

    void sortbyprice(List<ProductModel?> list) {
      list
        ..sort((a, b) => issortprice
            ? varietypricerange(b!.id)[0].compareTo(varietypricerange(a!.id)[0])
            : varietypricerange(a!.id)[0]
                .compareTo(varietypricerange(b!.id)[0]));
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
        BuildContext context, List<ProductModel?> productlist) {
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
                        sortbyname(allproductlist);
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
                        sortbyprice(allproductlist);
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
                        sortbyrank(allproductlist);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          elevation: 5);
    }

    List<int> ints = List<int>.generate(5, (i) => i * 6);

    productlist = productlist
        .where(
            (e) => e!.name!.toLowerCase().contains(filter?.toLowerCase() ?? ''))
        .toList();
    ints.remove(0);
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Expanded(
              child: Scaffold(
                appBar: (widget.title == 'Favoutite Products')
                    ? AppBar(
                        leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ))
                    : AppBar(
                        title: Text('Product List'),
                        leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )),
                body: (allproductlist.length == 0)
                    ? NewWidget()
                    : Column(
                        children: <Widget>[
                          Container(
                            child: RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Products in ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal),
                                  ),
                                  TextSpan(
                                    text: '${widget.title}',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            padding: EdgeInsets.all(8),
                          ),
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
                                      sortbottomsheet(context, productlist);
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        )),
                                    controller: controller,
                                  ),
                                ),
                              ),
                              SizedBox(width: 5),
                            ],
                          ),
                          (productlist.length == 0)
                              ? Center(child: Text('No Product Available'))
                              : Expanded(
                                  child: Container(
                                    child: ListView.separated(
                                      separatorBuilder: (ctx, idx) {
                                        // return ints.contains(idx)
                                        //     ? adwidget
                                        //     : Container();
                                        return SizedBox();
                                      },
                                      itemBuilder: (ctx, index) =>
                                          ProductListBox(
                                              product: productlist[index]),
                                      itemCount: productlist.length,
                                      shrinkWrap: true,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(UserAEForm.routeName);
                  },
                  child: Icon(Icons.add),
                ),
              ),
            ),
            // adwidget
          ],
        ),
      ),
      routes: {
        UserAEForm.routeName: (ctx) => UserAEForm(),
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
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
          Text('No Product Available Yet'),
          SizedBox(height: 2),
          Text('Start Adding Something OR Import Product Data'),
        ],
      ),
    );
  }
}
