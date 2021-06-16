import 'package:flutter/material.dart';

class MultiSelectChip extends StatefulWidget {
  final List<String?> reportList;
  final Function(List<String?>)? onSelectionChanged;
  final List<String?> preselected;
  MultiSelectChip(this.reportList, this.preselected, {this.onSelectionChanged});
  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String?> selectedChoices = [];
  _buildChoiceList() {
    List<Widget> choices = [];
    widget.reportList.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(4),
        child: ChoiceChip(
          label: Text(
            item!, 
            // style: TextStyle(color: Colors.white), 
          ),
          // selectedColor: Colors.blue,
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selectedChoices.contains(item)
                  ? selectedChoices.remove(item)
                  : selectedChoices.add(item);
              widget.onSelectionChanged!(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  void initState() {
    selectedChoices = widget.preselected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}
