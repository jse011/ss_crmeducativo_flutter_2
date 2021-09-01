import 'package:flutter/material.dart';

class DropDownFormField2<T> extends FormField<T> {
  final TextAlign? textAlign;
  final InputDecoration inputDecoration;
  final T? value;
  final Widget? hint;
  List<DropdownMenuItem<T>>? menuItems;
  final Function onChanged;



  DropDownFormField2(
      { this.textAlign,
        required this.inputDecoration,
        this.value,
        this.menuItems,
        required this.onChanged,
        this.hint})
      : super(
    initialValue: value == '' ? null : value,
    builder: (FormFieldState<T> state) {


      return Container(
        child: Stack(
          children: <Widget>[
            InputDecorator(
              textAlign: textAlign,
              decoration: inputDecoration,
            ),
            Container(
               padding: EdgeInsets.only(left: 15, right: 20),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<T>(
                    isExpanded: true,
                    icon: Container(),
                    hint: hint??Container(),
                    value: value == '' ? null : value,
                    onChanged: (newValue) {
                      state.didChange(newValue);
                      onChanged(newValue);
                    },
                    items: menuItems,
                  ),
                ),
            ),
          ],
        ),
      );
    },
  );



}