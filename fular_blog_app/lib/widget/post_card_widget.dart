import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:provider/provider.dart';

class PostCard extends StatelessWidget {
  PostCard({@required this.postModel, @required this.userModel, this.bookMark});
  final UserModel userModel;
  final PostModel postModel;
  final bool bookMark;
  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    return Container(
      padding: EdgeInsets.all(3),
      child: GestureDetector(
        onLongPress: (){
          showBottomSheet(
            backgroundColor: Colors.grey.withOpacity(0),
            context: context, 
            builder: (context){
              return Container(
                height: (userModel.uid == cuid) ? 120 : 60,
                //padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  
                  boxShadow: [
                    BoxShadow(color: Colors.white, offset: Offset(100, 100),blurRadius: 30,spreadRadius: 100)
                  ]
                ),
                child: (userModel.uid == cuid) ? Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.delete, color: Colors.black,),
                      title: Text("Delete this post",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      onTap: (){
                        postService.deletePost(postModel.pid);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.edit, color: Colors.black,),
                      title: Text("Edit this post",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                      onTap: (){
                        Navigator.pushNamed(context, "/postedit", arguments: postModel);
                        
                      },
                    ),
                  ],
                )
                :
                bookMark != true ? ListTile(
                  leading: Icon(Icons.bookmark, color: Colors.black,),
                  title: Text("Add Bookmark",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  onTap: () {
                    postService.addBookMark(postModel.pid);
                    Navigator.pop(context);
                  },
                ):
                ListTile(
                  leading: Icon(Icons.bookmark, color: Colors.black,),
                  title: Text("Delete Bookmark",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  onTap: () {
                    postService.deleteBookMark(postModel.pid);
                    Navigator.pop(context);
                  },
                ),
              );
            }
          );
        },
        onTap: (){
          postService.popularPost(postModel);
          List list =[postModel,userModel,bookMark];
          Navigator.of(context).pushNamed("/postview", arguments: list);
        },
        child: Card(
          shadowColor: Colors.black,
          child: Column(
            children:<Widget>[
              Container(
                child: postModel.photo.contains("firebasestorage") == true || postModel.photo != null ? 
                CachedNetworkImage(
                  imageUrl: postModel?.photo,
                  progressIndicatorBuilder: (context, url, downloadProgress) => 
                    CircularProgressIndicator(value: downloadProgress.progress),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                )
                :Container(color:Colors.red, width:50, height:50),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.height/50,
                  MediaQuery.of(context).size.height/50,
                  MediaQuery.of(context).size.height/50,
                  0
                  ),
                child: Row(
                  children: <Widget>[
                    userModel.photo.contains("firebasestorage") == true ? Container(
                      width: MediaQuery.of(context).size.width/15,
                      height: MediaQuery.of(context).size.width/15,
                      decoration: BoxDecoration(
                        //color: Colors.red,
                        borderRadius: BorderRadius.circular(999),
                        image:
                        userModel.photo != null ?
                         DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(userModel.photo),
                        ): null,
                        boxShadow: [
                          BoxShadow(

                            blurRadius: 0.3,
                            spreadRadius: 0.3,
                            offset: Offset(
                              0.0,
                              0.0,
                            ),
                          )
                        ],
                      ),
                    ): Container(
                      child: Icon(Icons.person, size: MediaQuery.of(context).size.width/15,)
                      ),
                    SizedBox(width:MediaQuery.of(context).size.width/50, ),
                    Expanded(
                      child: Text(userModel.username, 
                      style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
              postModel.title != "" ?
              Container(
                margin: EdgeInsets.all(MediaQuery.of(context).size.height/50),
                child: Text(postModel.title, textWidthBasis: TextWidthBasis.parent, style: TextStyle(fontSize:22, fontWeight: FontWeight.bold,),),
                alignment: Alignment.centerLeft,
              ): Container(color:Colors.red, width:50, height:50), 
              Padding(
                padding: EdgeInsets.all(MediaQuery.of(context).size.height/50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:<Widget>[
                    Text(postModel.dateTime.split(" ")[0], style: TextStyle(color: Colors.grey)),
                  ]
                ),
              )
            ]
          )
        ),
      ),
    );
  }
}