import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/user_service.dart';
import 'package:fular_blog_app/widget/image_widget.dart';
import 'package:provider/provider.dart';
import 'timeline_page_widget.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({this.uid});
  final String uid;
  @override
  Widget build(BuildContext context) {
    var userService = Provider.of<UserService>(context);
    var authService = Provider.of<AuthenticationService>(context);
    return StreamBuilder(
      stream: authService.getProfile(uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData){
          return Center(
            child: Text(
              'No Data...',
            ),
          );
        }
        else
        {
          UserModel userModel = UserModel.fromDataSnapShot(snapshot.data);
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex:1,
                    child: Container(
                      decoration: BoxDecoration(
                      ),
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width/25),
                      child: Row(
                        children:<Widget>[
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => ImagePage(photo: userModel.photo, isPost: false,)));
                            },
                            child: userModel.photo.contains("firebasestorage") == true ?Container(
                              width: MediaQuery.of(context).size.width/4,
                              height: MediaQuery.of(context).size.width/4,
                              margin: EdgeInsets.only(right:MediaQuery.of(context).size.width/25),
                              decoration: BoxDecoration(
                                /*border: Border.all(
                                  style: BorderStyle.solid
                                ),*/
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(userModel.photo),
                                )
                              ),
                              child: userModel.photo.contains("firebasestorage") == true ? null : Icon(Icons.person, size: MediaQuery.of(context).size.width/6,),
                            ): Container(
                              margin: EdgeInsets.only(right:MediaQuery.of(context).size.width/25),
                              child: Icon(Icons.person, size: MediaQuery.of(context).size.width/4,)
                              ),
                          ),
                          Expanded(
                            flex: 6,
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    userModel.username,
                                    //overflow: TextOverflow.ellipsis,
                                    style:TextStyle(
                                      fontSize: 24, 
                                      fontWeight: FontWeight.bold
                                    )
                                  ),
                                  Text(
                                    userModel.description, 
                                    style:TextStyle(
                                      fontSize: 16, 
                                      fontStyle: 
                                        FontStyle.italic,
                                        color: Colors.grey
                                    ),
                                  )
                                ]
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Row(
                              children: <Widget>[
                                uid != null && uid != cuid ? Container() : IconButton(
                                  icon: Icon(Icons.settings), 
                                  onPressed: (){
                                    userService.setImage(null);
                                    Navigator.pushNamed(context, "/settings", arguments: userModel);
                                  }
                                ),
                                uid != null && uid != cuid ? Container() : IconButton(
                                  icon: Icon(Icons.exit_to_app), 
                                  onPressed: (){
                                    authService.logOut();
                                    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
                                  }
                                ),
                              ],
                            )
                          )
                        ]
                      ),
                    )
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      child: TimelinePage(uid: (uid == null) ? cuid : uid,)
                    ),
                  )
                ],
              )
            ),
          );
        }
      }
    );
  }
}