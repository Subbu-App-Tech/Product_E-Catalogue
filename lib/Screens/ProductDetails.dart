import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/ProductDetailsW.dart';

class ProductDetails extends StatelessWidget {
  final String productid;
  ProductDetails(this.productid);
  @override
  Widget build(BuildContext context) {
    ProductModel loadproduct = Provider.of<ProductData>(context).findbyid(productid) ??
        ProductModel(name: '', id: '');
    return ProductDetailsW(loadproduct);
  }
}
