import 'package:flutter/material.dart';

class MyTextFieldWithPreFix extends StatelessWidget {
  TextEditingController textEditController;
  TextInputType textInputType;
  String label;
  bool validate;
  bool filled;

  MyTextFieldWithPreFix(
      {Key? key,
      required this.textEditController,
        required this.filled,
      required this.textInputType,
      required this.label,
      required this.validate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textEditController,
      keyboardType: textInputType,
      autovalidateMode:validate? AutovalidateMode.onUserInteraction:AutovalidateMode.disabled,
      validator: (v){
        if(v!.isEmpty && validate){
          return "$label is required";
        }
      },
      readOnly: filled,
      
      decoration: InputDecoration(
      filled: filled,
        fillColor: Colors.grey.withOpacity(.2),
        prefixIcon: Icon(Icons.edit),
        label: Text(label),
        contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.blue)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 1, color: Colors.grey)),
      ),
    );
  }
}
