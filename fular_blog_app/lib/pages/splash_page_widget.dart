import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key key}) : super(key: key);

  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {

  loadUid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String text = prefs.getString("cuid");
    setState(() {
      cuid = text;
    });
  }

  @override
  void initState() {
    super.initState();
    
    Future.delayed(const Duration(seconds: 2), () async {
      if (cuid == "" || cuid == null) {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
      }
    });
    loadUid();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(0, 0, 40, 1),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            Text(
              'Fular',
              style: GoogleFonts.lato(
                fontSize: 46,
                textStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  color: Colors.lightBlue, 
                  letterSpacing: .5
                ),
              ),
            ),
            SizedBox(height: 50,),
            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlue),)
          ],
      ),
        )
    );
  }
}