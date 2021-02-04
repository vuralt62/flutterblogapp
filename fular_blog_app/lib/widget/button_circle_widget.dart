import 'package:flutter/material.dart';

class ButtonCircle extends StatelessWidget {
  ButtonCircle({@required this.text, @required this.onpressed});
  final String text;
  final Function onpressed;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      onPressed: onpressed,
      padding: EdgeInsets.fromLTRB(
        MediaQuery.of(context).size.width/8, 
        MediaQuery.of(context).size.height/50, 
        MediaQuery.of(context).size.width/8, 
        MediaQuery.of(context).size.height/50
        ),
      color: Color.fromRGBO(201, 82, 177, 1),
      child: Text('$text', style: TextStyle(color: Colors.white,fontSize: 20)),
    );
  }
}