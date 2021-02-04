import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fular_blog_app/model/users_model.dart';

UserModel userModel;
class PostModel{
  String pid;
  String uid;
  String photo;
  String title;
  String content;
  String dateTime;
  int tapped;

  PostModel({this.uid, this.photo, this.title, this.content, this.dateTime, this.pid, this.tapped});

    PostModel.fromJson(Map<String, dynamic> json)
      : pid = json['pid'],
        uid = json['uid'],
        photo = json['photo'],
        title = json['title'],
        content = json['content'],
        dateTime = json['datetime'];

    Map<String, dynamic> toJson() =>
    {
      'pid': pid,
      'uid': uid,
      'photo': photo,
      "title": title,
      'content': content,
      'dateTime': dateTime
    };


  PostModel.fromDataSnapShot(DocumentSnapshot documentSnapshot) {
    pid = documentSnapshot.documentID;
    uid = documentSnapshot.data['uid'];
    title = documentSnapshot.data['title'];
    photo = documentSnapshot.data['photo'];
    content = documentSnapshot.data['content'];
    dateTime = documentSnapshot.data['date'];
    tapped = documentSnapshot.data['tapped'];
  }
}