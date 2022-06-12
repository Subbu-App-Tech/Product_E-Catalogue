import 'package:flutter/material.dart';
import 'package:productcatalogue/export.dart';

class MultiSelectChip extends StatefulWidget {
  final Product product;
  MultiSelectChip({Key? key, required this.product}) : super(key: key);
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  @override
  void didChangeDependencies() {
    allCategList = Provider.of<ProductData>(context).uqCategList;
    super.didChangeDependencies();
  }

  List<String> allCategList = [];
  @override
  Widget build(BuildContext context) {
    List<String> selectedChoices = widget.product.categories;
    allCategList.addAll(widget.product.categories);
    allCategList = allCategList.toSet().toList();
    return Wrap(
      children: allCategList
          .map((e) => Container(
                padding: const EdgeInsets.all(4),
                child: ChoiceChip(
                  label: Text(e),
                  selectedColor: Colors.blue,
                  selected: selectedChoices.contains(e),
                  onSelected: (ss) {
                    setState(() => widget.product.addRemoveCateg(e));
                  },
                ),
              ))
          .toList(),
    );
  }
}
