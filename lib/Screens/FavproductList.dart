import 'package:flutter/material.dart';
import '../Models/ProductModel.dart';
import '../Widgets/ProductListBox.dart';
import '../Screens/UserAEFrom.dart';
import '../Provider/VarietyDataP.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';

class FavProductsList extends StatefulWidget {
  static const routeName = '/FavProductsList';
  @override
  _FavProductsListState createState() => _FavProductsListState();
}

class _FavProductsListState extends State<FavProductsList> {
  TextEditingController controller = new TextEditingController();
  bool issortname = false;
  String filter;
  bool issortprice = false;
  bool issortrank = false;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final varietypricerange = Provider.of<VarietyData>(context).minmaxvalue;
    // List<ProductModel> productlist = Provider.of<ProductData>(context).;
    List<ProductModel> productlist =
        Provider.of<ProductData>(context).favoriteItems;
    // favproducts = favproductlist;
    void sortbyname(List<ProductModel> list) {
      list
        ..sort((a, b) => issortname
            ? b.name.toLowerCase().compareTo(a.name.toLowerCase())
            : a.name.toLowerCase().compareTo(b.name.toLowerCase()));
      issortname = !issortname;
      setState(() {});
    }

    void sortbyprice(List<ProductModel> list) {
      list
        ..sort((a, b) => issortprice
            ? varietypricerange(b.id)[0].compareTo(varietypricerange(a.id)[0])
            : varietypricerange(a.id)[0].compareTo(varietypricerange(b.id)[0]));
      issortprice = !issortprice;
      setState(() {});
    }

    void sortbyrank(List<ProductModel> list) {
      list
        ..sort((a, b) =>
            issortrank ? (b.rank).compareTo(a.rank) : a.rank.compareTo(b.rank));
      issortrank = !issortrank;
      setState(() {});
    }

    void sortbottomsheet(BuildContext context, List<ProductModel> productlist) {
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

                        sortbyname(productlist);
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
                        sortbyprice(productlist);
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
                        sortbyrank(productlist);
                      },
                    ),
                  )
                ],
              ),
            );
          },
          elevation: 5);
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: Text('Fav Product List'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            )),
        body: (productlist.length == 0)
            ? Center(
                child: Column(mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      child: Image.asset('assets/emptybox.png'),
                      width: 150,
                    ),
                    Text('No Product in Favourite'),
                    // SizedBox(height: 2),
                    // Text('Start Adding Something OR Import Product Data'),
                  ],
                ),
              )
            : Column(
                children: <Widget>[
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
                                  borderRadius: BorderRadius.circular(8),
                                )),
                            controller: controller,
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                    ],
                  ),
                  (productlist.length == 0)
                      ? Center(child: Text('No Product Available for Your Search'))
                      : ListView.builder(
                          itemBuilder: (ctx, index) =>
                          filter == null || filter == ''
                                    ? ProductListBox(product:productlist[index])
                                    : productlist[index]
                                            .name
                                            .toLowerCase()
                                            .contains(filter.toLowerCase())
                                        ? ProductListBox(product:productlist[index])
                                        : SizedBox.shrink(),
                              // ProductListBox(productlist[index]),
                          itemCount: productlist.length,
                          shrinkWrap: true,
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
      routes: {
        UserAEForm.routeName: (ctx) => UserAEForm(),
      },
    );
  }
}
