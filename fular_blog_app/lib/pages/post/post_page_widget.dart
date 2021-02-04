import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:fular_blog_app/widget/image_widget.dart';
import 'package:provider/provider.dart';

class PostViewPage extends StatefulWidget {
  PostViewPage({@required this.list});
  final List list;

  @override
  _PostViewPageState createState() => _PostViewPageState();
}

class _PostViewPageState extends State<PostViewPage> {
  final controller = ScrollController();
  bool isBook;


  @override
  Widget build(BuildContext context) {
  var postService = Provider.of<PostService>(context);
  PostModel postModel = widget.list[0];
  UserModel userModel = widget.list[1];
  bool isBookmark = widget.list[2];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ImagePage(photo: postModel.photo, isPost: true,)));
                },
                child: Image.network(
                  postModel.photo,
                  fit: BoxFit.fill,
                  width: MediaQuery.of(context).size.width,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                    if (loadingProgress == null)
                      return child;
                    return Container(
                      height: MediaQuery.of(context).size.width/2,
                      color: Colors.black,
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                              : null,
                        ),
                      ),
                    );
                  }
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  MediaQuery.of(context).size.width/25,
                  MediaQuery.of(context).size.width/25,
                  MediaQuery.of(context).size.width/25,
                  0
                ),
                child: Text(
                  postModel.title, 
                  style: TextStyle(
                    fontSize:36, 
                    color:Colors.black, 
                    fontWeight:FontWeight.bold
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.popAndPushNamed(context, "/profile", arguments: postModel.uid);
                    },
                    child: Row(
                      children: <Widget>[
                        userModel.photo.contains("firebasestorage") == true ? Container(
                          width: MediaQuery.of(context).size.width/8,
                          height: MediaQuery.of(context).size.width/8,
                          margin: EdgeInsets.all(MediaQuery.of(context).size.width/25),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(userModel.photo),
                            )
                          ),
                        ) : Icon(Icons.person, size: MediaQuery.of(context).size.width/6,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(userModel.username.substring(0,userModel.username.length<20 ? userModel.username.length : 20), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text(postModel.dateTime.split(" ")[0])
                          ],
                        ),
                      ],
                    ),
                  ),
                  userModel.uid != cuid ? IconButton(
                    icon: Icon(
                      (isBook == null ? isBookmark : isBook) ? 
                      Icons.bookmark : Icons.bookmark_border
                    ),
                    onPressed: (){
                      if (isBookmark == true) {
                        postService.deleteBookMark(postModel.pid);
                      } else {
                        postService.addBookMark(postModel.pid);
                      }
                      setState(() {
                        if(isBook == null){
                          if(isBookmark == true){
                            isBook = false;
                          }
                          else{
                            isBook = true;
                          }
                        }
                        else{
                          if(isBook == true){
                            isBook = false;
                          }
                          else{
                            isBook = true;
                          }
                        }
                      });
                    }
                  ) : Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.edit), 
                        onPressed: (){
                          Navigator.pushNamed(context, "/postedit", arguments: postModel);
                        }
                      ),
                      IconButton(
                        icon: Icon(Icons.delete), 
                        onPressed: (){
                          postService.deletePost(postModel.pid);
                          Navigator.pop(context);
                        }
                      )
                    ],
                  )
                ],
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width/20,
                    0,
                    MediaQuery.of(context).size.width/20,
                    0
                    ),
                  child: MarkdownBody(
                    shrinkWrap: true,
                    selectable: true,
                    data: postModel.content,
                    styleSheetTheme: MarkdownStyleSheetBaseTheme.material,
                    styleSheet: MarkdownStyleSheet.fromTheme(
                      ThemeData(
                        textTheme:TextTheme(
                          bodyText2:TextStyle(
                            fontSize: 16
                          )
                        )
                      )
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

