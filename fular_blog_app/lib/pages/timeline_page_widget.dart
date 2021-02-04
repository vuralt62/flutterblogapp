import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/widget/post_card_widget.dart';


class TimelinePage extends StatefulWidget {
  TimelinePage({this.uid});
  final String uid;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<UserModel> list=[];
  List isbookmarked=[];

  Future<void> getUser()async{
    QuerySnapshot timelineposts = await Firestore.instance.collection("users").getDocuments();
    List<UserModel> list1 =
    timelineposts.documents.map((doc) => UserModel.fromDataSnapShot(doc)).toList();
    setState(() {
      list = list1;
    });
  }

  Future<void> getBookmark()async{
    print(cuid);
    var query = Firestore.instance.collection("users/" + cuid + "/bookmark").getDocuments();
    QuerySnapshot bookmarkpost = await query;
    if (bookmarkpost != null) {
      List list1 =
      bookmarkpost.documents.map((doc) => doc.documentID).toList();
      setState(() {
        isbookmarked = list1;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUser();
    getBookmark();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: StreamBuilder(
            stream: (widget.uid == "") ? Firestore.instance.collection("posts").limit(30).orderBy("date", descending: true).snapshots() : Firestore.instance.collection("posts").where("uid" ,isEqualTo : widget.uid).orderBy("date", descending: true).snapshots().asBroadcastStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No Data...',
                  ),
                );
              } else { 
                
                return StaggeredGridView.countBuilder(
                  shrinkWrap: true,
                  crossAxisCount: snapshot.data.documents.length != 0 ?4:1,
                  itemCount: snapshot.data.documents.length != 0 ?snapshot.data.documents.length :1, 
                  itemBuilder: (BuildContext context, int index){ 
                    if (snapshot.data.documents.length != 0) {
                      PostModel postModel = PostModel.fromDataSnapShot(snapshot.data.documents[index]);
                      UserModel userModel = list.firstWhere((user) => user.uid == postModel.uid, orElse: () => null);
                      bool bookMark = isbookmarked.contains(postModel.pid);
                      return PostCard(postModel: postModel, userModel: userModel, bookMark: bookMark,);
                    } else {
                      return FittedBox(
                        fit: BoxFit.contain,
                        //color: Colors.amber,
                        //height: MediaQuery.of(context).size.height/1.2, 
                      child: Container(
                        color: Colors.grey[100],
                        padding: EdgeInsets.all(20),
                        child: Text("No Post"),
                      )
                      );
                    }

                  },
                  staggeredTileBuilder: (_) => StaggeredTile.fit(2),
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                );
              }
            }
          ),
        )
      ),
    );
  }
}
/*
class TimelinePage extends StatefulWidget {
  TimelinePage({this.my});
  bool my = false;

  @override
  _TimelinePageState createState() => _TimelinePageState();
}

class _TimelinePageState extends State<TimelinePage> {
  List<Map<String, dynamic>> mapList = List<Map<String, dynamic>>();
getAll(){
  Map<String, dynamic> map;
  List<Map<String, dynamic>> list = List<Map<String, dynamic>>();
  Stream<QuerySnapshot> snapshots = Firestore.instance.collection("posts").orderBy("date", descending: true).limit(30).snapshots().asBroadcastStream();
  snapshots.listen((event) {
    event.documents.forEach((element)async {
      DocumentSnapshot snap = await Firestore.instance.collection("users").document(element.data["uid"]).get();
      map = {
        "description": snap.data["descrition"],
        "username": snap.data["username"],
        "uid": snap.data["uid"],
        "pphoto": snap.data["photo"],
        "content": element.data["content"],
        "date" : element.data["date"],
        "photo": element.data["photo"],
        "title": element.data["title"],
        "pid":snap.documentID,
      };
      list.add(map);
    });
  });
  
return list;
}

getMyPost(){
  Map<String, dynamic> map;
  List<Map<String, dynamic>> list = List<Map<String, dynamic>>();
  Stream<QuerySnapshot> snapshots = Firestore.instance.collection("posts").where("uid" ,isEqualTo : cuid).orderBy("date", descending: true).limit(30).snapshots().asBroadcastStream();
  snapshots.listen((event) {
    event.documents.forEach((element)async {
      DocumentSnapshot snap = await Firestore.instance.collection("users").document(element.data["uid"]).get();
      map = {
        "description": snap.data["descrition"],
        "username": snap.data["username"],
        "uid": snap.data["uid"],
        "pphoto": snap.data["photo"],
        "content": element.data["content"],
        "date" : element.data["date"],
        "photo": element.data["photo"],
        "title": element.data["title"],
        "pid":snap.documentID,
      };
      list.add(map);
    });
  });
  
return list;
}
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      if(widget.my){
        mapList = getMyPost();
      }
      else mapList = getAll();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: mapList.length, 
        staggeredTileBuilder: (_) => StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        itemBuilder: (context, index){
          return PostCard(postModel: mapList[index], bookMark: false,);
        }
      )
    );
  }
}*/