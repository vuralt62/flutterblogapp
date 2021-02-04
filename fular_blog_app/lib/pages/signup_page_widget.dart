import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/auth_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/widget/button_circle_widget.dart';
import 'package:fular_blog_app/widget/textfield_widget.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  AuthModel authModel;
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 222, 250, 1),
      body: SingleChildScrollView(
        child: Builder(
          builder:(context) => Container(
            margin: EdgeInsets.fromLTRB(
              MediaQuery.of(context).size.width/20, 
              MediaQuery.of(context).size.width/2.5,
              MediaQuery.of(context).size.width/20,
              0
            ),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25)
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  TextfieldNormal(hintText: "Username", controller: usernameController,),
                  SizedBox(height: MediaQuery.of(context).size.height/50,),
                  TextfieldNormal(hintText: "Email", controller: emailController, keyboardType: TextInputType.emailAddress,),
                  SizedBox(height: MediaQuery.of(context).size.height/50,),
                  TextfieldNormal(hintText: "Password", controller: passwordController, password: true,),
                  SizedBox(height: MediaQuery.of(context).size.height/50,),
                  TextfieldNormal(hintText: "Password", controller: passwordController2, password: true,),
                  SizedBox(height: MediaQuery.of(context).size.height/25,),
                  ButtonCircle(
                    text: "SignUp", 
                    onpressed: ()async{
                      if (passwordController.text == passwordController2.text){
                        List<String> list = await search(usernameController.text.toLowerCase());
                        await authService.signUpWithEmail({
                          'email': emailController.text,
                          'password': passwordController.text,
                          "username": usernameController.text,
                          'uid': "",
                        }, list).catchError(
                          (e){
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content: Row(
                                children: <Widget>[
                                  Icon(Icons.error),
                                  SizedBox(width: 10,),
                                  Text(e)
                                ],
                              ),
                              duration: Duration(seconds: 2),
                              elevation: 0,
                            ));
                          }
                        ).whenComplete((){
                          Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                        });
                      }
                      else{
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: <Widget>[
                              Icon(Icons.error),
                              SizedBox(width: 10,),
                              Text("Passwords do not match")
                            ],
                          ),
                          duration: Duration(seconds: 2),
                          elevation: 0,
                        ));
                      }
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

search(String text){
  List<String> splitList = text.split(" ");
  List<String> indexList = [];
  if (splitList.length==1) {
    for (var i = 1; i < splitList[0].length+1; i++) {
      indexList.add(splitList[0].substring(0,i));
    }
  }
  else
  {
    for (var i = 0; i < splitList.length; i++) {
      for (var y = 1; y < splitList[i].length+1; y++) {
      indexList.add(splitList[i].substring(0,y));
      }
    }
  }
  return indexList;
}