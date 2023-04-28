import 'package:contact_crud_hive/model/user.dart';
import 'package:flutter/material.dart';

class FormContactFielder extends StatelessWidget {
  TextEditingController controller;
  String hintTextName;
  IconData iconData;
  bool enable;
  TextInputType textInputType;

  FormContactFielder(
      {super.key,
      required this.controller,
      required this.hintTextName,
      required this.iconData,
      this.enable = true,
      this.textInputType = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable,
      controller: controller,
      decoration: InputDecoration(
        icon: Icon(iconData),
        hintText: hintTextName,
        filled: true,
      ),
      keyboardType: textInputType,
      validator: (value) {
        if(enable){
          if ( value == null || value.isEmpty) {
            return 'Por Favor Digite $hintTextName';
          }
          if (hintTextName == 'Email' && !validateEmail(value)) {
            return 'Digite um Email Válido';
          }
        }
      },
    );
  }
}

validateEmail(String email) {
  final emailReg = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
  return emailReg.hasMatch(email);
}
