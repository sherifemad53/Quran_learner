import 'package:flutter/material.dart';

class FormTextField extends StatelessWidget {
  FormTextField({
    Key? key,
    required this.labeltext,
    required this.inputdata,
    required this.validator,
  }) : super(key: key);

  String? Function(String? str) validator;
  String? inputdata, labeltext;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: TextFormField(
        key: key,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: labeltext,
          border: const OutlineInputBorder(),
        ),
        onSaved: (newValue) {
          inputdata = newValue.toString();
        },
        validator: validator,
      ),
    );
  }
}
