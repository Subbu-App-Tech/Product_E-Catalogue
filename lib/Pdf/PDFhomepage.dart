import 'package:flutter/material.dart';
import '../Pdf/Grid/GridViewPV.dart';
import '../Pdf/Grid/Gridonlypicdesc.dart';
import '../Pdf/Grid/Gridvarietyvertical.dart';
import '../Pdf/Grid/GridDefinedSize.dart';
import '../Pdf/Grid/GridpicVariety.dart';
import '../Pdf/ListView/Listviewone.dart';

class PDFDicv extends StatelessWidget {
  final bool ispaid;
  const PDFDicv({Key? key, required this.ispaid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            child: Card(
                child: ListTile(
              title: Text('Create Product Catalogue for All Product'),
              subtitle: Text('Create Product Catalogue as PDF'),
              onTap: () {
                Navigator.pushNamed(context, PDFbrandscatlogue.routeName,
                    arguments: ['all', ispaid]);
              },
            ))),
        Divider(),
        Container(
            padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
            child: Card(
                child: ListTile(
              title: Text('Create Product Catalogue by Brand'),
              subtitle: Text('Create Product Catalogue as PDF'),
              onTap: () {
                Navigator.pushNamed(context, PDFbrandscatlogue.routeName,
                    arguments: ['brand', ispaid]);
              },
            ))),
        Divider(),
        Container(
            padding: const EdgeInsets.fromLTRB(10, 1, 1, 1),
            child: Card(
                child: ListTile(
              title: Text('Create Product Catalogue by Category'),
              subtitle: Text('Create Product Catalogue as PDF'),
              onTap: () {
                Navigator.pushNamed(context, PDFbrandscatlogue.routeName,
                    arguments: ['cat', ispaid]);
              },
            ))),
      ],
    );
  }
}

class PDFbrandscatlogue extends StatelessWidget {
  static const routeName = '/PDFbrandscatlogue';
  const PDFbrandscatlogue({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? sortby;
    Future<String?> dialog(BuildContext context) {
      return showDialog(
        useRootNavigator: true,
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Product Order"),
          elevation: 10,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Sort by Product Added',
                        textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop('none');
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Sort by Product Name',
                        textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop('name');
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('Sorted by Rank', textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop('rank');
                  },
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(15, 7, 15, 7),
                // ignore: deprecated_member_use
                child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child:
                        Text('Sorted by Variety', textAlign: TextAlign.center),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop('variety');
                  },
                ),
              )
            ],
          ),
          actions: [
            // ignore: deprecated_member_use
            RaisedButton(
              child: Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop('close');
              },
            )
          ],
        ),
      );
    }

    bool clicked(String? value) {
      if (value == null) {
        return false;
      } else if (value == 'close') {
        return false;
      } else {
        return true;
      }
    }

    List vallst = ModalRoute.of(context)!.settings.arguments as List;
    String value = '${vallst[0]}';
    bool ispaid = vallst[1];
    return Scaffold(
        appBar: AppBar(title: Text('Export Product Catalogue')),
        body: ListView(
          shrinkWrap: true,
          children: [
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Grid >> Model : 1'),
                  subtitle: Text('Create Catalogue with Picture & its Variety'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(context, PDFGridViewPV.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Grid >> Model : 2'),
                  subtitle:
                      Text('Create Catalogue with Picture & Variety Details'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(context, PDFGridPicDecs.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Grid >> Model : 3'),
                  subtitle: Text('Create Catalogue with Picture & Variety'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(
                          context, PDFGridpicVarietyVertical.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Grid >> Model : 4'),
                  subtitle: Text('Create Catalogue with Default template size'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(context, PDFGriddefinedsize.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('Grid >> Model : 5'),
                  subtitle:
                      Text('Create Catalogue with Picture & Variety Only'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(
                          context, PDFGridpicVarietyonly.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
            Container(
                padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                child: Card(
                    child: ListTile(
                  title: Text('List >> Model : 6'),
                  subtitle: Text('Create Catalogue with List view'),
                  onTap: () async {
                    sortby = await dialog(context);
                    if (clicked(sortby)) {
                      Navigator.pushNamed(context, PDFListviewone.routeName,
                          arguments: [value, sortby, ispaid]);
                    }
                  },
                ))),
            Divider(),
          ],
        ));
  }
}
