import 'package:flutter/material.dart';

class MyTextFormBox<T> extends StatelessWidget {
  final String title;
  final T value;
  final Function(T) onChange;
  final int maxLines;
  final bool validate;
  final bool isNullable;
  const MyTextFormBox(
      {Key? key,
      required this.title,
      required this.value,
      required this.onChange,
      this.maxLines = 1,
      this.validate = false,
      this.isNullable = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isdouble = T is double?;
    bool isint = T is int?;
    TextEditingController _cont = TextEditingController(
        text: isdouble
            ? (value as double).toStringAsFixed(2)
            : value?.toString());
    return TextFormField(
      controller: _cont,
      decoration: InputDecoration(labelText: title),
      maxLines: maxLines,
      textInputAction: TextInputAction.newline,
      keyboardType: TextInputType.multiline,
      onChanged: (v) {
        if (T.toString().startsWith('double')) {
          onChange((double.tryParse(v) as T) ?? value);
        } else if (T.toString().startsWith('int')) {
          onChange((int.tryParse(v) ?? value) as T);
        } else {
          onChange(v.toString() as T);
        }
      },
      validator: (v) {
        if (isdouble) {
          return (double.tryParse(v.toString()) == null && !isNullable)
              ? 'Please Enter Valid Data'
              : null;
        } else if (isint) {
          return ((int.tryParse(v.toString()) == null) && !isNullable)
              ? 'Please Enter Valid Data'
              : null;
        } else {
          return ((v?.toString() ?? '').isEmpty && !isNullable)
              ? 'This Must Not Be Empty'
              : null;
        }
      },
    );
  }
}
