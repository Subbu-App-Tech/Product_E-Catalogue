import 'package:flutter/material.dart';
import '../Widgets/ProductListBox.dart';
import '../Provider/ProductDataP.dart';
import '../Tool/FilterProduct.dart';
import '../Screens/Import.dart';
import '../contact/Aboutus.dart';
import 'Form/product_form.dart';

class ProductsList extends StatefulWidget {
  final bool isFavOnly;
  static const routeName = '/productlist';
  const ProductsList({this.isFavOnly = false});
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  TextEditingController controller = new TextEditingController();
  String? filter;
  Filtertool filtertool = Filtertool();
  List<Product> filteredlist = [];
  List<Product> allproductlist = [];
  Filterdata filterdata = Filterdata(brandlist: [], categorylist: []);
  List<String> brandlist = [];
  bool issortname = false;
  bool issortprice = false;
  bool issortrank = false;
  // final _nativeAdmob = NativeAdmob();
  @override
  void initState() {
    filterdata.isFavOnly = widget.isFavOnly;
    controller.addListener(() {
      setState(() => filter = controller.text);
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
    allproductlist = Provider.of<ProductData>(context).items;
    super.didChangeDependencies();
  }

  void sortbyname(List<Product?> list) {
    list
      ..sort((a, b) => issortname
          ? (b!.name.toLowerCase()).compareTo((a!.name.toLowerCase()))
          : (a!.name.toLowerCase()).compareTo((b!.name.toLowerCase())));
    issortname = !issortname;
    setState(() {});
  }

  void sortbyrank(List<Product?> list) {
    list
      ..sort((a, b) => issortrank
          ? b!.rank!.compareTo(a!.rank!)
          : a!.rank!.compareTo(b!.rank!));
    issortrank = !issortrank;
    setState(() {});
  }

  void sortbottomsheet(BuildContext context, List<Product?>? productlist) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Container(
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    leading: Icon(Icons.sort_by_alpha),
                    title:
                        issortname ? Text('By Name Z-A') : Text('By Name A-Z'),
                    onTap: () {
                      Navigator.pop(context);
                      sortbyname(productlist!);
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

  bool? issort;
  @override
  Widget build(BuildContext context) {
    filteredlist = filtertool.filteredproduct(allproductlist, filterdata);

    Widget filterchip() {
      if (filterdata.brandlist.isEmpty && filterdata.categorylist.isEmpty) {
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
                (filterdata.brandlist.isEmpty)
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
                                  label: Text('${filterdata.brandlist[idx]}',
                                      style: TextStyle(fontSize: 12)),
                                  avatar: Icon(Icons.cancel, size: 15),
                                  onSelected: (_) {
                                    setState(() {
                                      filterdata.brandlist.removeAt(idx);
                                    });
                                  }),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: filterdata.brandlist.length,
                        ),
                      ),
                (filterdata.categorylist.isEmpty)
                    ? SizedBox(width: 2)
                    : Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: ListView.builder(
                          itemBuilder: (ctx, idx) {
                            return Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: FilterChip(
                                  label: Text(filterdata.categorylist[idx],
                                      style: TextStyle(fontSize: 12)),
                                  avatar: Icon(Icons.cancel, size: 15),
                                  onSelected: (_) {
                                    setState(() {
                                      filterdata.categorylist.removeAt(idx);
                                    });
                                  }),
                            );
                          },
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: filterdata.categorylist.length,
                        ),
                      )
              ],
            ),
          ),
        );
      }
    }

    List<int> ints = List<int>.generate(5, (i) => i * 7);
    ints.remove(0);
    filteredlist = filteredlist
        .where(
            (e) => (e.name.toLowerCase()).contains(filter?.toLowerCase() ?? ''))
        .toList();
    return (allproductlist.isEmpty)
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
                          setState(() {});
                        }
                      })
                ],
              ),
              (filteredlist.length == 0)
                  ? Center(
                      child: Text('No Product Available At your Filter',
                          textAlign: TextAlign.center))
                  : Flexible(
                      child: Container(
                        child: ListView.builder(
                            itemBuilder: (ctx, index) {
                              return ProductListBox(
                                  product: filteredlist[index]);
                            },
                            itemCount: filteredlist.length,
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
