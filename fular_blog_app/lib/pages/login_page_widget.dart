import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/widget/button_circle_widget.dart';
import 'package:fular_blog_app/widget/textfield_widget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthenticationService>(context);
    return Scaffold(
      backgroundColor: Color.fromRGBO(187, 222, 250, 1),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Column(
            children: <Widget>[
              SizedBox(height:MediaQuery.of(context).size.height/6),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ClipPath(
                    clipper: RoundedDiagonalPathClipper(),
                    child: Material(
                      color: Color.fromRGBO(187, 222, 250, 1),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width/1.25,
                            height: MediaQuery.of(context).size.height/1.75,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(50.0)),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Form(
                                key:  _formKey,
                                child: Center(
                                  child: Column(
                                    children:<Widget>[
                                      SizedBox(height:MediaQuery.of(context).size.height/5),
                                      TextfieldNormal(
                                        hintText: "Email",
                                        controller: emailController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.emailAddress,
                                      ),
                                      SizedBox(height:MediaQuery.of(context).size.height/50),
                                      TextfieldNormal(
                                        password: true,
                                        hintText: "Password",
                                        controller: passwordController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Please enter some text';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(height:MediaQuery.of(context).size.height/25),
                                      ButtonCircle(
                                        text: "Login", 
                                        onpressed: ()async{
                                          
                                          if (_formKey.currentState.validate())
                                          //ilk ifin içine al
                                            _formKey.currentState.save();
                                          bool isLogged = await authService.login(emailController.text, passwordController.text);
                                          
                                          if (isLogged == true) {
                                            Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                                          }
                                          else {
                                            Scaffold.of(context).showSnackBar(SnackBar(
                                              content: Row(
                                                children: <Widget>[
                                                  Icon(Icons.error),
                                                  SizedBox(width: 10,),
                                                  Text("Email or password wrong")
                                                ],
                                              ),
                                              duration: Duration(seconds: 2),
                                              elevation: 0,
                                            ));
                                          }
                                        }
                                      ),
                                    ]
                                  )
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.width/200,
                    child: Container(
                      width: MediaQuery.of(context).size.width/4,
                      height: MediaQuery.of(context).size.width/4,
                      //margin: EdgeInsets.only(right:MediaQuery.of(context).size.width/25),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        /*image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage("https://pbs.twimg.com/profile_images/1025666733556809728/GO7ds-c-_400x400.jpg"),
                        )*/
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height:MediaQuery.of(context).size.height/50),
              Align(
                alignment: Alignment.bottomCenter,
                child: ButtonCircle(
                  text: "Signup", 
                  onpressed: (){
                    Navigator.pushNamed(context, "/signup");
                  }
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}

