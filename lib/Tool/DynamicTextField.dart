import 'package:flutter/material.dart';
import '../Models/VarietyProduct.dart';

class DynamicTextForm extends StatelessWidget {
  final VarietyProductM variety;
  final VoidCallback delete;
  final GlobalKey<FormState> keyform;
  const DynamicTextForm(
      {Key? key,
      required this.variety,
      required this.delete,
      required this.keyform})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController ncont = TextEditingController();
    final TextEditingController pcont = TextEditingController();
    final TextEditingController qcont = TextEditingController();
    ncont.text = this.variety.name;
    pcont.text = this.variety.price.toString();
    qcont.text = this.variety.wsp.toString();
    return Row(
      children: [
        Expanded(
          child: Container(
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Variety Name *'),
                    controller: ncont,
                    onChanged: variety.updatename,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please provide a value.';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          decoration:
                              InputDecoration(labelText: 'Variety Price'),
                          controller: pcont,
                          onChanged: (val) => this
                              .variety
                              .updateprice(double.tryParse(val) ?? 0),
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Variety WSP'),
                          controller: qcont,
                          keyboardType: TextInputType.number,
                          onChanged: (val) =>
                              this.variety.updatewsp(double.tryParse(val) ?? 0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
            color: Colors.red, icon: Icon(Icons.close), onPressed: this.delete),
      ],
    );
  }
}
