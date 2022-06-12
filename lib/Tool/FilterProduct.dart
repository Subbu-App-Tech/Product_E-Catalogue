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
  List<String?> brandlist = [];
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
                          onBrandChange: (valuelist) {
                            filterdata.brandlist = valuelist;
                          },
                        )
                  // : MultiSelectChipGroup(
                  //     items: brandlist,
                  //     preSelectedItems: filterdata.brandlist,
                  //     disabledColor: Colors.grey[250],
                  //     selectedColor: Colors.blue,
                  //     horizontalChipSpacing: 10,
                  //     labelDisabledColor: Colors.black,
                  //     labelSelectedColor: Colors.white,
                  //     labelFontSize: 12,
                  //     onSelectionChanged: (valuelist) {
                  //       filterdata.brandlist = valuelist;
                  //       setState(() {});
                  //     },
                  //   )
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
      productlistmodel.removeWhere((e) => !filterdata.categorylist.contains(e));
    }
    if (filterdata.brandlist.isNotEmpty) {
      productlistmodel.removeWhere((e) => !filterdata.brandlist.contains(e));
    }
    if (filterdata.isFavOnly) {
      productlistmodel.removeWhere((e) => !e.favourite);
    }
    return productlistmodel;
  }
}

class Filterdata {
  List<String> categorylist;
  List<String> brandlist;
  bool isFavOnly;
  Filterdata(
      {required this.brandlist,
      required this.categorylist,
      this.isFavOnly = false});
}

class BrandSelectionChip extends StatefulWidget {
  final List<String?> brandlist;
  final Function(List<String>) onBrandChange;
  const BrandSelectionChip(
      {Key? key, required this.brandlist, required this.onBrandChange})
      : super(key: key);

  @override
  State<BrandSelectionChip> createState() => _BrandSelectionChipState();
}

class _BrandSelectionChipState extends State<BrandSelectionChip> {
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.brandlist
          .map(
            (e) => FilterChip(
                onSelected: (b) => setState(() {
                      final ccpy = [...widget.brandlist];
                      ccpy.contains(e) ? ccpy.remove(e) : ccpy.add(e);
                    }),
                label: Text(e ?? '--', style: TextStyle(color: Colors.white)),
                selected: widget.brandlist.contains(e),
                selectedColor: Colors.blue),
          )
          .toList(),
    );
  }
}
