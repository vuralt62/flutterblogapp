import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:fular_blog_app/services/post_service.dart';
import 'package:fular_blog_app/services/user_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/provider.dart';



class PostEditingPage extends StatefulWidget {
  PostEditingPage({this.postModel});
  final PostModel postModel;

  @override
  _PostEditingPageState createState() => _PostEditingPageState();
}

class _PostEditingPageState extends State<PostEditingPage> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController contentController = TextEditingController();

  final TextEditingController controller = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.postModel != null) {
      setState(() {
        titleController.text = widget.postModel.title;
        contentController.text = widget.postModel.content;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var postService = Provider.of<PostService>(context);
    var userService = Provider.of<UserService>(context);
    return Scaffold(
      appBar: AppBar(
        //title: Text("Post"),
        leading: Container(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.title), 
            onPressed: (){
              if (contentController.selection.start != -1) {
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "\n# "+text2+ "\n"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+3, 
                      extentOffset: selection.extentOffset+3, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
                else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "\n# "+text2;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+3, 
                      extentOffset: selection.extentOffset+3, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }        
            }
          ),
          IconButton(
            icon: Icon(Icons.format_italic), 
            onPressed: (){
              if (contentController.selection.start != -1) {
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "*"+text2+"*"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+2, 
                      extentOffset: selection.extentOffset+2, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "*"+text2;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+1, 
                      extentOffset: selection.extentOffset+1, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.format_bold), 
            onPressed: (){
              if (contentController.selection.start != -1) {
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "**"+text2+"**"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+4, 
                      extentOffset: selection.extentOffset+4, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "**"+text2;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+2, 
                      extentOffset: selection.extentOffset+2, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.code), 
            onPressed: (){
              if (contentController.selection.start !=-1) {
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "\n```\n"+text2+"\n```\n"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+10, 
                      extentOffset: selection.extentOffset+10, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "\n```\n"+text2;
                  //contentController.selection = TextSelection(baseOffset: selection.baseOffset+5, extentOffset: selection.extentOffset+5);
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+5, 
                      extentOffset: selection.extentOffset+5, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }
            }
          ),
          IconButton(
            icon: Icon(Icons.strikethrough_s),
            onPressed: (){
              if (contentController.selection.start != -1) {
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "~~"+text2+"~~"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+4, 
                      extentOffset: selection.extentOffset+4, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "~~"+text2;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+2, 
                      extentOffset: selection.extentOffset+2, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              } else {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.check_box),
            onPressed: (){
              if(contentController.selection.start != -1){
                String text= contentController.text;
                var selection = contentController.selection;
                if (contentController.selection.start != contentController.selection.end) {
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.selection.end);
                  String text3 = text.substring(contentController.selection.end, contentController.text.length);
                  text = text1 + "\n- [x]"+" `"+text2+"`"+"\n"+text3;
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+10, 
                      extentOffset: selection.extentOffset+10, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }else if(contentController.selection.start == contentController.selection.end){
                  String text1 = text.substring(0,contentController.selection.start);
                  String text2 = text.substring(contentController.selection.start, contentController.text.length);
                  text = text1 + "\n- [x] ' '\n"+text2;
                  //contentController.selection = TextSelection(baseOffset: selection.baseOffset+8, extentOffset: selection.extentOffset+8);
                  contentController.value = contentController.value.copyWith(
                    text: text, 
                    selection: TextSelection(
                      baseOffset: selection.extentOffset+8, 
                      extentOffset: selection.extentOffset+8, 
                      affinity: selection.affinity, 
                      isDirectional: selection.isDirectional
                    )
                  );
                }
              }
              else{
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Row(
                    children: <Widget>[
                      Icon(Icons.error),
                      SizedBox(width: 10,),
                      Text("Only content field")
                    ],
                  ),
                  duration: Duration(seconds: 2),
                  elevation: 0,
                ));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          String content = contentController.text;
          String title = titleController.text;
          if(_formKey.currentState.validate()){
            _formKey.currentState.save();
            contentController.text = "";
            titleController.text = "";
            String url;
            if ((userService.image != null || widget.postModel.photo != "") && contentController.text != null && titleController.text != null) {
              
              DateTime dateTime = DateTime.now();
              List<String> list = await search(title.toLowerCase());
              if (widget.postModel == null) {
                url = await userService.uploadImage("post", userService.image);
                postService.postAdd({
                  'uid': cuid,
                  'content': content,
                  'date': dateTime.toString(),
                  'photo': url,
                  'title': title,
                  'search': list
                }).whenComplete(() {
                  title = "";
                  content = "";
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.send),
                        SizedBox(width: 10,),
                        Text("Send")
                      ],
                    ),
                    duration: Duration(seconds: 2),
                    elevation: 0,
                  ));
                });
              } else {
                url = userService.image != null ? await userService.uploadImage("post", userService.image) : null;
                postService.postUpdate({
                  'uid': cuid,
                  'content': content,
                  'date': dateTime.toString(),
                  'photo': url == null ? widget.postModel.photo : url,
                  'title': title,
                  'search': list
                },widget.postModel.pid).whenComplete(() {
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Row(
                      children: <Widget>[
                        Icon(Icons.send),
                        SizedBox(width: 10,),
                        Text("Updated")
                      ],
                    ),
                    duration: Duration(seconds: 2),
                    elevation: 0,
                  ));
                  
                });
                Navigator.pop(context);
              }
            }
            else{
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Row(
                  children: <Widget>[
                    Icon(Icons.image),
                    SizedBox(width: 10,),
                    Text("No Selected Image")
                  ],
                ),
                duration: Duration(seconds: 2),
                elevation: 0,
              ));
            }
          }
        }, 
        child:Icon(Icons.send)
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width / 10),
        child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
              (userService.image!=null || widget.postModel != null)?Column(
                children: <Widget>[
                  userService.image!=null ? Image.file(userService.image) : Image.network(widget.postModel.photo),
                  FlatButton(
                    child: Icon(Icons.image),
                    onPressed: ()async{
                      await userService.cropImage(CropAspectRatio(ratioX: 16, ratioY: 9), CropStyle.rectangle, );
                    },
                  ),
                ],
              )
              :
              IconButton(
                icon: Icon(Icons.image),
                onPressed: ()async{
                  await userService.cropImage(CropAspectRatio(ratioX: 16, ratioY: 9), CropStyle.rectangle, );
                },
              ),
              TextFormField(
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration(hintText: "Title"),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contentController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                maxLength: null,
                decoration: InputDecoration(hintText: "Content"),
                onChanged: (text){
                  
                },
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ]
          )
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