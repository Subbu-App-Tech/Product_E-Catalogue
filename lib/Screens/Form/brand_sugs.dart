import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:productcatalogue/export.dart';

class BrandSuggessionBx extends StatefulWidget {
  final Product product;
  const BrandSuggessionBx({Key? key, required this.product}) : super(key: key);

  @override
  State<BrandSuggessionBx> createState() => _BrandSuggessionBxState();
}

class _BrandSuggessionBxState extends State<BrandSuggessionBx> {
  @override
  Widget build(BuildContext context) {
    final suggestions = Provider.of<ProductData>(context).uqBrandList;
    final _brandcontroller = TextEditingController(text: widget.product.brand);
    return TypeAheadField(
      // key: key,
      textFieldConfiguration: TextFieldConfiguration(
          onChanged: (value) => widget.product.updatebrand(value),
          controller: _brandcontroller,
          decoration: InputDecoration(labelText: 'Brand Name')),
      suggestionsCallback: (pattern) => suggestions
          .where((s) => s.toLowerCase().contains(pattern.toLowerCase())),
      itemBuilder: (context, dynamic suggestion) {
        return Container(
            child: Text(
              suggestion,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
            padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
            color: Colors.white);
      },
      hideSuggestionsOnKeyboardHide: true,
      getImmediateSuggestions: true,
      onSuggestionSelected: (String? suggestion) {
        _brandcontroller.text = suggestion ?? '';
        widget.product.updatebrand(_brandcontroller.text);
      },
    );
  }
}
