import 'package:flutter/material.dart';
import '../Models/VarietyProductModel.dart';
import 'package:flutter/services.dart';

class AddVariety extends StatefulWidget {
  AddVariety({Key? key}) : super(key: key);
  static const routeName = '/add-variet';

  @override
  _AddVarietyState createState() => _AddVarietyState();
}

class _AddVarietyState extends State<AddVariety> {
  List<VarietyProductM> varietymodel = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trail'),
        actions: <Widget>[
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () => null,
            child: Icon(Icons.add),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListView.builder(
            itemCount: varietymodel.length,
            itemBuilder: (build, index) {
              return DynamicTextField(
                  variety: varietymodel[index],
                  delete: () {
                    setState(() {
                      varietymodel.removeAt(index);
                      print(index);
                    });
                  });
            },
            shrinkWrap: true,
          ),          
          // ignore: deprecated_member_use
          RaisedButton(
            onPressed: () {
              setState(() {
                varietymodel.add(VarietyProductM(
                    productid: null,
                    id: null,
                    varityname: '',
                    price: 0,
                    wsp: 0));
              });
            },
            child: Text('Add Variety'),
          ),
        ],
      ),
    );
  }
}

class DynamicTextField extends StatelessWidget {
  final TextEditingController ncont = TextEditingController();
  final TextEditingController pcont = TextEditingController();
  final VarietyProductM variety;
  final Function delete;
  DynamicTextField({Key? key, required this.variety, required this.delete})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (variety.varityname != '') {
      ncont.text = variety.varityname!;
    }
    if (variety.price != 0) {
      pcont.text = variety.price.toString();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: TextFormField(
              decoration: InputDecoration(labelText: 'Variety Name'),
              controller: ncont,
              onChanged: (val) {
                variety.updatename(val);
              }),
        ),
        SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            decoration: InputDecoration(labelText: 'Variety Price'),
            controller: pcont,
            keyboardType: TextInputType.number,
            onChanged: (val) {
              variety.updateprice(double.parse(val));
            },
          ),
        ),
        IconButton(
            color: Colors.amber,
            icon: Icon(Icons.close),
            onPressed: delete as void Function()?),
      ],
    );
  }
}
