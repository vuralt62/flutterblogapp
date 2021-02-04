import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:fular_blog_app/widget/post_card_widget.dart';
import 'package:provider/provider.dart';

class BookmarkPage extends StatefulWidget {
  @override
  _BookmarkPageState createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  TabController controller;

List<UserModel> users=[];
List bookMark=[];

Future<void> getUser()async{
  QuerySnapshot timelineposts = await Firestore.instance.collection("users").getDocuments();
  List<UserModel> list1 =
  timelineposts.documents.map((doc) => UserModel.fromDataSnapShot(doc)).toList();
  setState(() {
    users = list1;
  });
}

Future<void> getBookMark()async{
  QuerySnapshot timelineposts = await Firestore.instance.collection("users").document(cuid).collection("bookmark").getDocuments();
  List list1 =
  timelineposts.documents.map((doc) => doc.documentID).toList();
  setState(() {
    bookMark = list1;
  });
}

@override
void initState() { 
  super.initState();
  getUser();
  getBookMark();
}

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    return Scaffold(
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: bookMark.length,
        itemBuilder: (context, index){
          return StreamBuilder(
          stream: postService.getBookMarkID(bookMark[index]) ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.hasData) {
              if (snapshot.data.data != null) {
              PostModel postModel = PostModel.fromDataSnapShot(snapshot.data);
              UserModel userModel = users.firstWhere((element) => element.uid == postModel.uid, orElse: () => null,);
              return PostCard(postModel: postModel, userModel: userModel, bookMark: true,);
              }
              else return Center(child: CircularProgressIndicator());
            }
            else return Center();
            },
          );
        }
      )
    );
  }
}