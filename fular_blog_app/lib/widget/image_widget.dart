import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePage extends StatefulWidget {
  ImagePage({@required this.photo, @required isPost});
  final String photo;
  bool isPost;

  @override
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), 
          onPressed: (){
            Navigator.pop(context);
          }
        ),
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          child: widget.photo.contains("firebasestorage") == true ? PhotoView(
            imageProvider: NetworkImage(widget.photo)
          ) : Icon(widget.isPost != true ? Icons.person : Icons.image, color: Colors.white, size: MediaQuery.of(context).size.width,),
        )
      ),
    );
  }
}