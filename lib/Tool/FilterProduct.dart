import 'package:flutter/material.dart';
import '../Models/ProductModel.dart';
import '../Provider/ProductDataP.dart';
import 'package:provider/provider.dart';
import '../Screens/TabScreen.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
// import 'package:multiselectchipgroup/multiselectchipgroup.dart';
import '../Provider/CategoryDataP.dart';
// import 'package:grouped_checkbox/grouped_checkbox.dart';
import '../Widgets/Group/grouped_checkbox.dart';
import '../Widgets/Group/flutter_xlider.dart';
import '../Widgets/Group/multiselectchipgroup.dart';
import '../Provider/VarietyDataP.dart';

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
  List<double?> price = [];
  List<ProductModel?>? productlist;
  late List<String> catnamelist;
  List<String?> brandlist = [];
  late Function findidlist;
  late List<String> checkedItemList;
  List<String>? checkedbrandlist;
  Function? varietyrangefunc;
  late Filterdata filterdata;
  RangeValues? _values;

  @override
  void initState() {
    filterdata = widget.filterdata ?? Filterdata();
    setState(() {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    productlist = Provider.of<ProductData>(context).items;
    for (ProductModel? i in productlist!) {
      if (i!.brand != null || i.brand != ' ' || i.brand != '') {
        brandlist.add(i.brand);
      }
    }
    brandlist = brandlist.toSet().toList();
    brandlist.remove('');
    catnamelist = Provider.of<CategoryData>(context).catnamelist();
    findidlist = Provider.of<CategoryData>(context).findidlist;
    price = Provider.of<VarietyData>(context).sortedpricelist();
    varietyrangefunc = Provider.of<VarietyData>(context).minmaxvalue;
    productlist =
        filtertool.filteredproduct(productlist, filterdata, varietyrangefunc);
    if (filterdata.rangeofprice != null) {
      _values = filterdata.rangeofprice;
    } else {
      _values = RangeValues(0, price.last!);
    }
    if (filterdata.categorylist != null) {
      checkedItemList = Provider.of<CategoryData>(context)
          .findcategorylist(filterdata.categorylist);
    } else {
      checkedItemList = [];
    }
    if (filterdata.brandlist != null) {
      checkedbrandlist = filterdata.brandlist;
    } else {
      checkedbrandlist = [];
    }
    brandlist.remove(null);
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
                title: Text('Price Range'),
                trailing: (filterdata.rangeofprice != null)
                    ? Text('${_values?.start} - ${_values?.end} ')
                    : null,
                children: [
                  (_values?.start == 0 && _values?.end == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text('No Product Variety Price Available'),
                        )
                      : Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Range: ${_values?.start} - ${_values?.end}',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 17)),
                              SizedBox(height: 10),
                              FlutterSlider(
                                values: [
                                  _values?.start ?? 0,
                                  _values?.end ?? 0
                                ],
                                min: 0,
                                rangeSlider: true,
                                max: price.last,
                                selectByTap: true,
                                onDragging:
                                    (handlerIndex, lowerValue, upperValue) {
                                  if (upperValue > price.last) {
                                    upperValue = price.last;
                                    _values =
                                        RangeValues(lowerValue, upperValue);
                                  } else {
                                    _values =
                                        RangeValues(lowerValue, upperValue);
                                  }
                                  setState(() {});
                                },
                                handlerAnimation: FlutterSliderHandlerAnimation(
                                    curve: Curves.elasticOut,
                                    reverseCurve: Curves.bounceIn,
                                    duration: Duration(milliseconds: 500),
                                    scale: 1.5),
                                tooltip: FlutterSliderTooltip(disabled: true),
                                onDragCompleted:
                                    (handlerIndex, lowerValue, upperValue) {
                                  if (upperValue > price.last) {
                                    upperValue = price.last;
                                  }
                                  filterdata = Filterdata(
                                      rangeofprice:
                                          RangeValues(lowerValue, upperValue),
                                      brandlist: filterdata.brandlist,
                                      categorylist: filterdata.categorylist);
                                  setState(() {
                                    productlist = filtertool.filteredproduct(
                                        productlist,
                                        filterdata,
                                        varietyrangefunc);
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
            Card(
                child: ExpansionTile(
              title: Text('Select Category'),
              trailing: checkedItemList.length == 0
                  ? null
                  : Text('${checkedItemList.length} Category selected'),
              children: <Widget>[
                (catnamelist.length == 0)
                    ? Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text('No Category Available'))
                    : GroupedCheckbox(
                        itemList: catnamelist.toSet().toList(),
                        checkedItemList: checkedItemList,
                        onChanged: (itemList) {
                          setState(() {
                            checkedItemList = itemList;
                            filterdata = Filterdata(
                                rangeofprice: filterdata.rangeofprice,
                                brandlist: filterdata.brandlist,
                                categorylist: findidlist(checkedItemList));
                            productlist = filtertool.filteredproduct(
                                productlist, filterdata, varietyrangefunc);
                          });
                        },
                        orientation: CheckboxOrientation.VERTICAL,
                        checkColor: Colors.white,
                        activeColor: Colors.blue),
              ],
            )),
            Card(
              child: ExpansionTile(
                title: Text('Select Brand'),
                trailing: checkedbrandlist!.length == 0
                    ? null
                    : Text('${checkedbrandlist!.length} Brands Selected'),
                children: <Widget>[
                  (brandlist.length == 0)
                      ? Padding(
                          padding: const EdgeInsets.all(25),
                          child: Text('No Brand Available'),
                        )
                      : MultiSelectChipGroup(
                          items: brandlist,
                          preSelectedItems: checkedbrandlist,
                          disabledColor: Colors.grey[250],
                          selectedColor: Colors.blue,
                          horizontalChipSpacing: 10,
                          labelDisabledColor: Colors.black,
                          labelSelectedColor: Colors.white,
                          labelFontSize: 12,
                          onSelectionChanged: (valuelist) {
                            checkedbrandlist = valuelist;
                            filterdata = Filterdata(
                                rangeofprice: filterdata.rangeofprice,
                                brandlist: checkedbrandlist,
                                categorylist: filterdata.categorylist);
                            productlist = filtertool.filteredproduct(
                                productlist, filterdata, varietyrangefunc);
                          },
                        )
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                RaisedButton(
                  onPressed: () {
                    filterdata = Filterdata(
                        brandlist: null,
                        categorylist: null,
                        rangeofprice: null);
                    _values = RangeValues(0, price.last!);
                    checkedbrandlist = [];
                    setState(() {});
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (ctx) =>
                                TabScreen(filterdata: filterdata)));
                  },
                  child: Text('Reset Filter'),
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      filterdata = Filterdata(
                          brandlist: filterdata.brandlist,
                          categorylist: filterdata.categorylist,
                          rangeofprice: filterdata.rangeofprice);
                    });
                    Navigator.pop(context, filterdata);
                    // Navigator.pushReplacement(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (ctx) =>
                    //             TabScreen(filterdata: filterdata)));
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
  List<ProductModel?>? filteredproduct(List<ProductModel?>? productlistmodel,
      Filterdata filterdata, Function? func) {
    if (filterdata.rangeofprice != null) {
      RangeValues? rangeofprice = filterdata.rangeofprice;
      // var func = VarietyData().minmaxvalue;
      // for (ProductModel i in productlistmodel){

      // }
      bool trval(ProductModel prdmodel) {
        if (func!(prdmodel.id) == null || func(prdmodel.id).length == 0) {
          return true;
        } else if (func(prdmodel.id).length == 1) {
          if (func(prdmodel.id)[0] >= rangeofprice!.start &&
              func(prdmodel.id)[0] <= rangeofprice.end) {
            return true;
          } else {
            return false;
          }
        } else if (func(prdmodel.id).length == 2) {
          if ((func(prdmodel.id)[0] >= rangeofprice!.start &&
                  func(prdmodel.id)[1] <= rangeofprice.end) ||
              (func(prdmodel.id)[1] >= rangeofprice.start &&
                  func(prdmodel.id)[0] <= rangeofprice.end)) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }

      productlistmodel = [...productlistmodel!.where((ele) => (trval(ele!)))];
      // productlistmodel = [
      //   ...productlistmodel.where((ele) =>
      //       (ele.price >= rangeofprice.start && ele.price <= rangeofprice.end))
      // ];
    }
    if (filterdata.categorylist != null) {
      if (filterdata.categorylist!.length > 0) {
        List<String>? categorylist = filterdata.categorylist;
        productlistmodel = [
          ...productlistmodel!.where((ele) => ele!.categorylist!
              .any((element) => categorylist!.contains(element)))
        ];
      }
    }
    if (filterdata.brandlist != null) {
      if (filterdata.brandlist!.length > 0) {
        List<String>? brandlist = filterdata.brandlist;
        productlistmodel = [
          ...productlistmodel!.where((ele) => brandlist!.contains(ele!.brand))
        ];
        // for (String i in brandlist) {
        //   productlistmodel = [
        //     ...productlistmodel.where((ele) => ele.brand == i)
        //   ];
        // }
      }
    }
    return productlistmodel;
  }
}

class Filterdata {
  RangeValues? rangeofprice;
  List<String>? categorylist;
  List<String>? brandlist;

  Filterdata({this.rangeofprice, this.brandlist, this.categorylist});
}
