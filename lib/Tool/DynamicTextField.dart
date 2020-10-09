import 'package:flutter/material.dart';
import '../Models/VarietyProductModel.dart';

class DynamicTextForm extends StatelessWidget {
  final VarietyProductM variety;
  final VoidCallback delete;
  final GlobalKey<FormState> keyform;
  const DynamicTextForm(
      {Key key, @required this.variety, @required this.delete, this.keyform})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController ncont = TextEditingController();
    final TextEditingController pcont = TextEditingController();
    final TextEditingController qcont = TextEditingController();
    if (this.variety.varityname != '') {
      ncont.text = this.variety.varityname;
    }
    if (this.variety.price != 0) {
      pcont.text = this.variety.price.toString();
    }
    if (this.variety.wsp != 0) {
      qcont.text = this.variety.wsp.toString();
    }
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
                    onChanged: (val) {
                      this.variety.updatename((val));
                    },
                    validator: (value) {
                      if (value.isEmpty) {
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
                          onChanged: (val) {
                            this.variety.updateprice(double.parse(val));
                          },
                        ),
                      ),
                      SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(labelText: 'Variety WSP'),
                          controller: qcont,
                          keyboardType: TextInputType.number,
                          onChanged: (val) {
                            this.variety.updatewsp(double.parse(val));
                          },
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
            color: Colors.red,
            icon: Icon(Icons.close),
            onPressed: this.delete),
      ],
    );
  }
}

// IconButton(
//     color: Colors.amber, icon: Icon(Icons.close), onPressed: this.delete),
// class DynamicTextField extends StatefulWidget {
//   final VarietyProductM variety;
//   final VoidCallback delete;
//   final GlobalKey<FormState> keyform;
//   DynamicTextField(
//       {Key key, @required this.variety, @required this.delete, this.keyform})
//       : super(key: key);

//   @override
//   _DynamicTextFieldState createState() => _DynamicTextFieldState();
// }

// class _DynamicTextFieldState extends State<DynamicTextField> {
//   final TextEditingController ncont = TextEditingController();
//   final TextEditingController pcont = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     if (widget.variety.varityname != '') {
//       ncont.text = widget.variety.varityname;
//     }
//     if (widget.variety.price != 0) {
//       pcont.text = widget.variety.price.toString();
//     }
//     void press() {
//       widget.delete;
//       ncont.clear();
//       pcont.clear();
//     }

//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[
//         Expanded(
//           child: TextFormField(
//             decoration: InputDecoration(labelText: 'Variety Name'),
//             controller: ncont,
//             onChanged: (val) {
//               widget.variety.updatename((val));
//               // print('value entered -------------->>>>  $val');
//             },
//             validator: (value) {
//               if (value.isEmpty) {
//                 return 'Please provide a value.';
//               }
//               return null;
//             },
//           ),
//         ),
//         SizedBox(width: 5),
//         Expanded(
//           child: TextFormField(
//             decoration: InputDecoration(labelText: 'Variety Price'),
//             controller: pcont,
//             keyboardType: TextInputType.number,
//             onChanged: (val) {
//               widget.variety.updateprice(double.parse(val));
//             },
//           ),
//         ),
//         IconButton(
//             color: Colors.amber, icon: Icon(Icons.close), onPressed: press),
//       ],
//     );
//   }
// }
