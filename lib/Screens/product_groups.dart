import 'package:flutter/material.dart';
import '../Provider/ProductDataP.dart';
import '../Widgets/GridW.dart';

class GridListTiles extends StatefulWidget {
  final bool isCateg;
  final Function(String?) onTap;
  const GridListTiles({Key? key, required this.isCateg, required this.onTap})
      : super(key: key);

  @override
  _GridListTilesState createState() => _GridListTilesState();
}

class _GridListTilesState extends State<GridListTiles> {

  // static const _adUnitID = "ca-app-pub-9568938816087708/6044993041";
  // late StreamSubscription _subscription;

  @override
  Widget build(BuildContext context) {
    List<Count> data = widget.isCateg
        ? Provider.of<ProductData>(context).categCountList
        : Provider.of<ProductData>(context).uqBrand;
    return (data.length == 0)
        ? Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // adwidget(true),
                Container(
                    child: Image.asset('assets/emptybox.png'), width: 150),
                Text('No Product Available Yet'),
                SizedBox(height: 2),
                Text('Start Adding Something\n(OR)\nImport Product Data',
                    textAlign: TextAlign.center),
                // adwidget(false)
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                // adwidget(true),
                GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2),
                  itemBuilder: (ctx, index) => GridViewW(
                    count: data[index].count,
                    name: data[index].name ?? ' -N- ',
                    isCateg: widget.isCateg,
                    onTap: () {
                      String? filt = data[index].name;
                      if (widget.isCateg && filt == null) return;
                      widget.onTap(filt);
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (ctx) => ProductListPg(
                      //               filterdata: Filterdata(
                      //                   brandlist: widget.isCateg ? [] : [filt],
                      //                   categorylist:
                      //                       widget.isCateg ? [filt!] : []),
                      //             )));
                    },
                  ),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: data.length,
                ),
                // adwidget(false)
              ],
            ),
          );
  }
}
