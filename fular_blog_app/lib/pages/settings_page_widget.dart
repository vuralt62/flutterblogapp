import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/user_service.dart';
import 'package:fular_blog_app/widget/button_circle_widget.dart';
import 'package:fular_blog_app/widget/textfield_widget.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({@required this.userModel});
  final UserModel userModel;
  final emailController = TextEditingController();
  final descriptionController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordController2 = TextEditingController();
  final usernameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var authService = Provider.of<AuthenticationService>(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color.fromRGBO(187, 222, 250, 1),
      body: SingleChildScrollView(
        child: Builder(
          builder: (context) => Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.fromLTRB(
                MediaQuery.of(context).size.width/20, 
                MediaQuery.of(context).size.width/3.5,
                MediaQuery.of(context).size.width/20,
                MediaQuery.of(context).size.width/3.5,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25)
              ),
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width/4,
                      height: MediaQuery.of(context).size.width/4,
                      margin: EdgeInsets.only(right:MediaQuery.of(context).size.width/25),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(187, 222, 250, 1),
                            spreadRadius: 2
                          )
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: (userService.image==null)?NetworkImage(userModel.photo):FileImage(userService.image),
                        )
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height/50,),
                    IconButton(
                      icon: Icon(Icons.image), 
                      onPressed: ()async{
                        //_image = await userService.getImage();
                        //userService.setImage(_image);
                        //if (userService.image !=null) {
                          await userService.cropImage(CropAspectRatio(ratioX: 1, ratioY: 1), CropStyle.circle, );
                        //}
                      }
                    )
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                TextfieldNormal(
                  hintText: "Username", 
                  controller: usernameController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                TextfieldNormal(
                  hintText: "Description", 
                  controller: descriptionController,
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                TextfieldNormal(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "Email", 
                  controller: emailController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                TextfieldNormal(
                  hintText: "Password", 
                  controller: passwordController, 
                  password: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height/50,),
                TextfieldNormal(
                  hintText: "Password", 
                  controller: passwordController2, 
                  password: true,
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    else if(value != passwordController.text){
                      return 'Şifreler eşleşmiyor';
                    }
                    return null;
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height/25,),
                ButtonCircle(
                  text: "Save", 
                  onpressed: ()async{
                    if (_formKey.currentState.validate()){
                      _formKey.currentState.save();
                      bool logged = await authService.login(emailController.text, passwordController.text);
                      if (logged == true) {
                        String url;
                        if (userService.image != null) {
                          url = await userService.uploadImage("profile", userService.image);
                          print("url : " + url);
                        }
                        authService.userUpdate({
                          "username": (usernameController.text!="") ? usernameController.text : userModel.username,
                          "description": (descriptionController.text!="") ? descriptionController.text : userModel.description,
                          //(userModel.photo=="")? null : "photo": userModel.photo,
                          "photo": (url == null) ? userModel.photo : url,
                          "uid":cuid
                        });
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Row(
                            children: <Widget>[
                              Icon(Icons.save),
                              SizedBox(width: 10,),
                              Text("Saved")
                            ],
                          ),
                          duration: Duration(seconds: 2),
                          elevation: 0,
                        ));
                      }
                      else{
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
                    userService.clearImage();
                  }
                ),
                ]
              ),
            ),
          ),
        ),
      )
    );
  }
}