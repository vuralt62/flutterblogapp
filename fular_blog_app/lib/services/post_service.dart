import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/post_model.dart';
import 'authentication_service.dart';

class PostService with ChangeNotifier{
  PostModel postModel;
  bool isBookMarked = false;
  var _dbHelper = Firestore.instance;

  popularPost(PostModel postModel){
    try {
      _dbHelper.collection("posts").document(postModel.pid).updateData({
        "tapped": postModel.tapped == null ? 1 : postModel.tapped+1
      });
    } catch (e) {
    }
  }

 postView(Map<dynamic, dynamic> map){
    postModel.uid = cuid;
    postModel.title = map["title"];
    postModel.photo = map["photo"] ?? "https://flutter.dev/assets/flutter-lockup-c13da9c9303e26b8d5fc208d2a1fa20c1ef47eb021ecadf27046dea04c0cebf6.png";
    postModel.content = map["content"];
    postModel.dateTime = DateTime.now().toString();
    notifyListeners();
  }

  Stream<QuerySnapshot> getProfilePost(String text){
    notifyListeners();
    return _dbHelper.collection("posts").where("uid" ,isEqualTo : text).orderBy("date", descending: true).snapshots();
  }

  getBookMarkID(id){
    notifyListeners();
    return _dbHelper.collection("posts").document(id).snapshots();
  }

  getBookMark(){
    notifyListeners();
    return _dbHelper.collection("users").document(cuid).collection("bookmark").getDocuments().asStream();
  }


  Stream<QuerySnapshot> getPost(){
    notifyListeners();
    return _dbHelper.collection("posts").orderBy("date", descending: true).limit(30).snapshots();
  }
  
  deletePost(String pid){
    try {
      _dbHelper.collection("posts").document(pid).delete();
    } catch (e) {
      print(e);
    }
  }

  addBookMark(String pid)async{
    try {
      await _dbHelper.collection("users").document(cuid).collection("bookmark").document(pid).setData({});
      //book = Icons.bookmark;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  deleteBookMark(String pid)async{
    try {
      await _dbHelper.collection("users").document(cuid).collection("bookmark").document(pid).delete();
      //book = Icons.bookmark_border;
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }
  
  Future postAdd(Map<String,dynamic> map) async{
    try {
      await _dbHelper.collection("posts").document().setData(map);
      
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future postUpdate(Map<String,dynamic> map, String pid) async{
    try {
      await _dbHelper.collection("posts").document(pid).updateData(map);
      
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

List<Map<String, dynamic>> list = List<Map<String, dynamic>>();

  getAll(){
    Map<String, dynamic> map;
    Firestore.instance.collection("posts").orderBy("date", descending: true).limit(30).snapshots().asBroadcastStream().listen((event) async{
      for (var element in event.documents) {
        DocumentSnapshot snap = await Firestore.instance.collection("users").document(element.data["uid"]).get();
        map = {
          "description": snap.data["descrition"],
          "username": snap.data["username"],
          "uid": snap.data["uid"],
          "pphoto": snap.data["photo"],
          "content": element.data["content"],
          "date" : element.data["date"],
          "photo": element.data["photo"],
          "title": element.data["title"]
        };
        list.add(map);
      }
    });
    notifyListeners();
  }

}