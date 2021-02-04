import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String uid;
  String description;
  String photo;
  String username;

  UserModel({this.description, this.photo, this.username, this.uid});

    UserModel.fromJson(Map<String, dynamic> json)
      : description = json['description'],
        photo = json['photo'],
        username = json['username'],
        uid = json['uid'];

    Map<String, dynamic> toJson() =>
    {
      'username': username,
      'photo': photo,
      'description': description,
      'uid': uid
    };

  UserModel.fromDataSnapShot(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.documentID;
    username = documentSnapshot.data['username'];
    photo = documentSnapshot.data['photo'];
    description = documentSnapshot.data['description'];
  }
  UserModel.fromDataSnapShot2(DocumentSnapshot documentSnapshot) {
    uid = documentSnapshot.documentID;
    username = documentSnapshot.data['username'];
    photo = documentSnapshot.data['photo'];
    description = documentSnapshot.data['description'];
  }

}