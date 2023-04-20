import 'package:flutter/material.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/ProductDetailsW.dart';

class ProductDetails extends StatelessWidget {
  final String? productid;
  ProductDetails(this.productid);
  @override
  Widget build(BuildContext context) {
    Product loadproduct =
        Provider.of<ProductData>(context).findbyid(productid)!;
    return ProductDetailsW(loadproduct);
  }
}
