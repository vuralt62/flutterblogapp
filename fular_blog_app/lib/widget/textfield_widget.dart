import 'package:flutter/material.dart';

class TextfieldNormal extends StatelessWidget {
  TextfieldNormal({@required this.hintText, @required this.controller,this.password, this.keyboardType, this.validator, this.onChanged, this.icon, this.autoFocus});
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) validator;
  final bool password;
  final Function(String) onChanged;
  final Widget icon;
  final bool autoFocus;
  
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      validator: validator,
      obscureText: password??false,
      keyboardType: keyboardType,
      controller: controller,
      showCursor: true,
      style: TextStyle(color:Colors.black),
      autofocus: (autoFocus==null)?false:autoFocus,
      decoration: InputDecoration(
        prefixIcon: icon,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(width: 1,color: Colors.blue,),
        ),
        enabledBorder: OutlineInputBorder(
          
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(width: 1,color: Color.fromRGBO(187, 222, 250, 1)),
        ),
        hintText: '$hintText',
        hintStyle: TextStyle(color: Color.fromRGBO(187, 222, 250, 1),fontWeight: FontWeight.bold),
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
  }
}