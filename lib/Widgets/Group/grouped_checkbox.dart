import 'package:flutter/material.dart';

enum CheckboxOrientation { HORIZONTAL, VERTICAL, WRAP }

class GroupedCheckbox extends StatefulWidget {
  final List<String> itemList;
  final List<String>? checkedItemList;
  final List<String>? disabled;
  final TextStyle textStyle;
  final CheckboxOrientation orientation;
  final Function onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final bool tristate;
  final MaterialTapTargetSize? materialTapTargetSize;
  final Color? focusColor;
  final Color? hoverColor;
  final Axis wrapDirection;
  final WrapAlignment wrapAlignment;
  final double wrapSpacing;
  final WrapAlignment wrapRunAlignment;
  final double wrapRunSpacing;
  final WrapCrossAlignment wrapCrossAxisAlignment;
  final VerticalDirection wrapVerticalDirection;
  final TextDirection? wrapTextDirection;

  GroupedCheckbox({
    required this.itemList,
    required this.orientation,
    required this.onChanged,
    this.checkedItemList,
    this.textStyle = const TextStyle(),
    this.disabled,
    this.activeColor,
    this.checkColor,
    this.focusColor,
    this.hoverColor,
    this.materialTapTargetSize,
    this.tristate = false,
    this.wrapDirection = Axis.horizontal,
    this.wrapAlignment = WrapAlignment.start,
    this.wrapSpacing = 0.0,
    this.wrapRunAlignment = WrapAlignment.start,
    this.wrapRunSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.wrapTextDirection,
    this.wrapVerticalDirection = VerticalDirection.down,
  });

  @override
  _GroupedCheckboxState createState() => _GroupedCheckboxState();
}

class _GroupedCheckboxState extends State<GroupedCheckbox> {
  List<String> selectedListItems = [];

  @override
  Widget build(BuildContext context) {
    Widget finalWidget = generateItems();
    return finalWidget;
  }

  Widget generateItems() {
    List<Widget> content = [];
    Widget finalWidget;
    if (widget.checkedItemList != null) {
      selectedListItems = widget.checkedItemList!;
    }
    List<Widget> widgetList = [];
    for (int i = 0; i < widget.itemList.length; i++) {
      widgetList.add(item(i));
    }
    if (widget.orientation == CheckboxOrientation.VERTICAL) {
      for (final item in widgetList) {
        content.add(Row(children: <Widget>[item]));
      }
      finalWidget = SingleChildScrollView(
          scrollDirection: Axis.vertical, child: Column(children: content));
    } else if (widget.orientation == CheckboxOrientation.HORIZONTAL) {
      for (final item in widgetList) {
        content.add(Column(children: <Widget>[item]));
      }
      finalWidget = SingleChildScrollView(
          scrollDirection: Axis.horizontal, child: Row(children: content));
    } else {
      finalWidget = SingleChildScrollView(
        child: Wrap(
            children: widgetList,
            spacing: widget.wrapSpacing,
            runSpacing: widget.wrapRunSpacing,
            textDirection: widget.wrapTextDirection,
            crossAxisAlignment: widget.wrapCrossAxisAlignment,
            verticalDirection: widget.wrapVerticalDirection,
            alignment: widget.wrapAlignment,
            direction: Axis.horizontal,
            runAlignment: widget.wrapRunAlignment),
      );
    }
    return finalWidget;
  }

  Widget item(int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Checkbox(
            activeColor: widget.activeColor,
            checkColor: widget.checkColor,
            focusColor: widget.focusColor,
            hoverColor: widget.hoverColor,
            materialTapTargetSize: widget.materialTapTargetSize,
            value: selectedListItems.contains(widget.itemList[index]),
            tristate: widget.tristate,
            onChanged: (widget.disabled
                        ?.contains(widget.itemList.elementAt(index)) ??
                    false)
                ? null
                : (bool? selected) {
                    if (selected != null) {
                      selected
                          ? selectedListItems.add(widget.itemList[index])
                          : selectedListItems.remove(widget.itemList[index]);
                      setState(() {
                        widget.onChanged(selectedListItems);
                      });
                    }
                  }),
        Text(
          widget.itemList[index].isEmpty ? '' : widget.itemList[index],
          style: (widget.disabled?.contains(widget.itemList.elementAt(index)) ??
                  false)
              ? TextStyle(color: Theme.of(context).disabledColor)
              : widget.textStyle,
        )
      ],
    );
  }
}
