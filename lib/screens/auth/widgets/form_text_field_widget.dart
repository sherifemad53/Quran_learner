import 'package:flutter/material.dart';

//ignore: must_be_immutable
class FormTextField extends StatelessWidget {
  FormTextField({
    Key? key,
    required this.labeltext,
    required this.validator,
    required this.textEditingController,
    this.isObscuretext,
  }) : super(key: key);

  String? Function(String? str) validator;
  String? labeltext;
  TextEditingController? textEditingController;
  bool? isObscuretext = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      keyboardType: TextInputType.name,
      decoration: InputDecoration(
        labelText: labeltext,
        border: const OutlineInputBorder(),
      ),
      onSaved: (newValue) {
        textEditingController!.text = newValue as String;
      },
      validator: validator,
      obscureText: isObscuretext as bool,
    );
  }
}
