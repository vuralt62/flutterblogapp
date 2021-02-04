import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:fular_blog_app/widget/post_card_widget.dart';
import 'package:fular_blog_app/widget/textfield_widget.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String name = "";
  List<UserModel> users=[];
  List<PostModel> posts=[];
  List isbookmarked=[];
  bool isPost = true;

  Future<void> getUser()async{
    QuerySnapshot timelineposts = await Firestore.instance.collection("users").getDocuments();
    List<UserModel> list1 =
    timelineposts.documents.map((doc) => UserModel.fromDataSnapShot(doc)).toList();
    setState(() {
      users = list1;
    });
  }

  Future<void> getPost()async{
    QuerySnapshot timelineposts = await Firestore.instance.collection("posts").orderBy("tapped", descending: true).limit(10).getDocuments();
    List<PostModel> list1 =
    timelineposts.documents.map((doc) => PostModel.fromDataSnapShot(doc)).toList();
    setState(() {
      posts = list1;
    });
  }

  Future<void> getBookmark()async{
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
    getPost();
    getBookmark();
  }
  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextfieldNormal(
                      autoFocus: false,
                      icon: Icon(
                        Icons.search,
                        color: Colors.blue,
                      ),
                      hintText: "Search",
                      controller: null,
                      onChanged: (text) {
                        initiateSearch(text);
                      }
                    ),
                  ),
                  IconButton(
                    icon: Icon(isPost == true ? Icons.format_align_left :Icons.person), 
                    onPressed: (){
                      setState(() {
                        isPost = !isPost;
                      });
                    }
                  )
                ],
              ),
              SizedBox(height:8),
              Container(
                height: name != ""? MediaQuery.of(context).size.height/0.1 :0,
                child: StreamBuilder<QuerySnapshot>(
                  stream: name != "" && name != null
                      ? (isPost == true ? Firestore.instance
                          .collection('posts')
                          .where("search", arrayContains: name)
                          .snapshots() : Firestore.instance
                          .collection('users')
                          .where("search", arrayContains: name)
                          .snapshots())
                      : null,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        default:
                          return (name != "")
                              ? (isPost == true ? ListView(
                                //padding: EdgeInsets.all(8),
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                      PostModel postModel = PostModel.fromDataSnapShot(document);
                                      String subtitle = postModel.content.split("\n")[0];
                                    return Container(
                                      margin: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blue[100],
                                      ),
                                      child: ListTile(
                                        title: Text(
                                          document['title'],
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(subtitle.substring(0,subtitle.length < 30 ? subtitle.length : 50),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        onTap: () async {
                                          var profile = await Firestore.instance
                                              .collection("users")
                                              .document(document["uid"])
                                              .get();
                                          if (profile != null) {
                                            UserModel userModel =
                                                UserModel.fromDataSnapShot(
                                                    profile);
                                            bool bookMark = isbookmarked.contains(postModel.pid);
                                            List list = [postModel, userModel, bookMark];
                                            postService.popularPost(postModel);
                                            Navigator.pushNamed(
                                                context, "/postview",
                                                arguments: list);
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ): ListView(
                                  children: snapshot.data.documents
                                      .map((DocumentSnapshot document) {
                                        UserModel userModel = UserModel.fromDataSnapShot(document);
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.popAndPushNamed(context, "/profile", arguments: userModel.uid);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8),
                                            margin: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Colors.blue[100],
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                userModel.photo.contains("firebasestorage") == true ? Container(
                                                  width: MediaQuery.of(context).size.width/6,
                                                  height: MediaQuery.of(context).size.width/6,
                                                  margin: EdgeInsets.only(right:MediaQuery.of(context).size.width/25),
                                                  decoration: BoxDecoration(
                                                    /*border: Border.all(
                                                      style: BorderStyle.solid
                                                    ),*/
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: NetworkImage(userModel.photo),
                                                    ),
                                                  ),
                                                  child: userModel.photo.contains("firebasestorage") == true ? null : Icon(Icons.person, size: MediaQuery.of(context).size.width/6,)
                                                ): Icon(Icons.person, size: MediaQuery.of(context).size.width/6,),
                                                Text(userModel.username, style:TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                                              ],
                                            )
                                          ),
                                        );
                                      }).toList()
                                ))
                              : Container();
                      }
                    } else
                      return Container();
                  },
                ),
              ),
              SizedBox(height:10),
              name == "" ? Container(
                //height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(" Popular", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
                    SizedBox(height:10),
                    Container(
                      height: MediaQuery.of(context).size.height/1.5,
                      child: ListView.builder(
                        itemCount: posts.length,
                        itemBuilder: (context, index){
                          PostModel postModel = posts[index];
                          UserModel userModel = users.firstWhere((user) => user.uid == postModel.uid, orElse: () => null);
                          bool bookMark = isbookmarked.contains(postModel.pid);
                          return PostCard(postModel: postModel, userModel: userModel, bookMark: bookMark,);
                        }
                      )
                    ),
                  ],
                )
              ): Container(),
              SizedBox(height:30)
            ],
          ),
        ),
      ),
    );
  }

  void initiateSearch(String val) {
    setState(() {
      name = val.toLowerCase().trim();
    });
  }
}
