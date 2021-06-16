import 'package:flutter/material.dart';
// import '../Models/ProductModel.dart';
import '../Screens/FilteredProductList.dart';

class GridViewW extends StatelessWidget {
  final String? title;
  final int? count;
  final String? catid;
  final String? brand;
  // final String catid;
  final VoidCallback? delete;
  // final List<ProductModel> productlist;
  GridViewW(
      {required this.title, this.count, this.brand, this.catid, this.delete});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (count != 0) {
          if (brand != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => FilteredProductsList(
                          brand: brand,
                          // productlist: productlist,
                          title: title,
                        )));
          } else if (catid != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (ctx) => FilteredProductsList(
                          catid: catid,
                          // productlist: productlist,
                          title: title,
                        )));
          }
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
                    '$title',
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
              (count == 0)
                  ? Positioned(
                      top: .5,
                      right: .5,
                      child: Container(
                        padding: EdgeInsets.all(.01),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.white,
                            size: 20,
                          ),
                          onPressed: this.delete,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
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
