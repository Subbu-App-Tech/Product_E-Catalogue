import 'package:flutter/material.dart';
// import '../Models/ProductModel.dart';
import '../Screens/FilteredProductList.dart';

class GridViewW extends StatelessWidget {
  final int count;
  final String name;
  final bool isCateg;
  GridViewW({required this.count, required this.name, required this.isCateg});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isCateg) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      FilteredProductsList(brand: name, title: name)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (ctx) =>
                      FilteredProductsList(catName: name, title: name)));
        }
      },
      child: Card(
        child: GridTile(
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bluebag.jpg'),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.blue[400],
                  border:
                      Border.all(width: 1.0, color: const Color(0xff9a9a9a)),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0x2e000000),
                        offset: Offset(2, 3),
                        blurRadius: 3)
                  ],
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(7),
                  color: Colors.black38,
                  width: double.infinity,
                  child: Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      EdgeInsets.only(bottom: 3, top: 3, left: 7, right: 7),
                  color: Colors.black38,
                  child: Text(
                    '$count Items',
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
        elevation: 5,
      ),
    );
  }
}
