import 'package:flutter/material.dart';

import '../Provider/ProductDataP.dart';
import '../Screens/TabScreen.dart';
import '../Widgets/Group/grouped_checkbox.dart';

class FilterProduct extends StatefulWidget {
  static const routeName = '/filtertool';
  final Filterdata? filterdata;
  FilterProduct({Key? key, this.filterdata}) : super(key: key);

  @override
  _FilterProductState createState() => _FilterProductState();
}

class _FilterProductState extends State<FilterProduct> {
  bool isExpanded = false;
  Filtertool filtertool = Filtertool();
  List<String> catNameList = [];
  List<String> brandlist = [];
  late Filterdata filterdata;

  @override
  void initState() {
    filterdata =
        widget.filterdata ?? Filterdata(brandlist: [], categorylist: []);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    catNameList = Provider.of<ProductData>(context).uqCategList;
    brandlist = Provider.of<ProductData>(context).uqBrandList;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
                child: ExpansionTile(
              title: Text('Select Category'),
              trailing: filterdata.categorylist.isEmpty
                  ? null
                  : Text('${filterdata.categorylist.length} Category selected'),
              children: <Widget>[
                (catNameList.length == 0)
                    ? Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text('No Category Available'))
                    : GroupedCheckbox(
                        itemList: catNameList.toSet().toList(),
                        checkedItemList: filterdata.categorylist,
                        onChanged: (itemList) {
                          filterdata.categorylist = itemList;
                          setState(() {});
                        },
                        orientation: CheckboxOrientation.VERTICAL,
                        checkColor: Colors.white,
                        activeColor: Colors.blue),
              ],
            )),
            Card(
              child: ExpansionTile(
                title: Text('Select Brand'),
                trailing: filterdata.brandlist.isEmpty
                    ? null
                    : Text('${filterdata.brandlist.length} Brands Selected'),
                children: <Widget>[
                  (brandlist.length == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text('No Brand Available'))
                      : BrandSelectionChip(
                          brandlist: brandlist,
                          selecBrandlist: () => filterdata.brandlist,
                          onBrandChange: (valuelist) {
                            filterdata.brandlist = valuelist;
                          },
                        )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      filterdata = Filterdata(brandlist: [], categorylist: []);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) =>
                                  TabScreen(filterdata: filterdata)));
                    },
                    child: Text('Reset Filter')),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      filterdata = Filterdata(
                          brandlist: filterdata.brandlist,
                          categorylist: filterdata.categorylist);
                    });
                    Navigator.pop(context, filterdata);
                  },
                  child: Text('Apply Filter'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Filtertool {
  List<Product> filteredproduct(
      List<Product> productlistmodel, Filterdata filterdata) {
    if (filterdata.categorylist.isNotEmpty) {
      productlistmodel.removeWhere(
          (e) => !filterdata.categorylist.any((a) => e.categories.contains(a)));
    }
    if (filterdata.brandlist.isNotEmpty) {
      productlistmodel
          .removeWhere((e) => !filterdata.brandlist.contains(e.brand));
    }
    if (filterdata.isFavOnly) {
      productlistmodel.removeWhere((e) => !e.favourite);
    }
    return productlistmodel;
  }
}

class Filterdata {
  List<String> categorylist;
  List<String?> brandlist;
  bool isFavOnly;
  Filterdata(
      {required this.brandlist,
      required this.categorylist,
      this.isFavOnly = false});

  @override
  String toString() =>
      'Filterdata(categorylist: $categorylist, brandlist: $brandlist, isFavOnly: $isFavOnly)';
}

class BrandSelectionChip extends StatefulWidget {
  final List<String> brandlist;
  final List<String?> Function() selecBrandlist;
  final Function(List<String?>) onBrandChange;
  const BrandSelectionChip(
      {Key? key,
      required this.brandlist,
      required this.onBrandChange,
      required this.selecBrandlist})
      : super(key: key);

  @override
  State<BrandSelectionChip> createState() => _BrandSelectionChipState();
}

class _BrandSelectionChipState extends State<BrandSelectionChip> {
  @override
  Widget build(BuildContext context) {
    final selecBrandlist = widget.selecBrandlist();
    return Wrap(
      children: widget.brandlist
          .map(
            (e) => FilterChip(
                onSelected: (b) => setState(() {
                      final ccpy = [...selecBrandlist];
                      ccpy.contains(e) ? ccpy.remove(e) : ccpy.add(e);
                      print(ccpy);
                      widget.onBrandChange(ccpy);
                    }),
                label: Text(e,
                    style: TextStyle(
                        color: selecBrandlist.contains(e)
                            ? Colors.white
                            : Colors.black)),
                selected: selecBrandlist.contains(e),
                checkmarkColor: Colors.white,
                selectedColor: Colors.blue),
          )
          .toList(),
    );
  }
}
