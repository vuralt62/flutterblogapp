import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/auth_model.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

  String cuid="";

class AuthenticationService extends ChangeNotifier{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  var dbHelper = Firestore.instance;
  UserService userService;



  Future signUpWithEmail(Map<String,String> map,List list) async {
    AuthModel authModel = AuthModel.fromJson(map);
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      );
      map["uid"] =authResult.user.uid;
      
    } catch (e) {
      print(e);
    }
    if (map["uid"]!="") {
      
      await userAdd({
        'uid': map["uid"],
        'description': "",
        //'email': map["email"],
        'photo': "https://lh3.googleusercontent.com/proxy/T6IeQuPpes7UTByNh0HkQfChkh29iCZOAx2Tpdw7dqIp_tXOsgMwJ5MBDTRd3sAp4KTkVOh4ewtHJKjqsHMVNX87GaXuPCk1YZpacrd1N_nWnrGTPALvo87vxVUrS-nWOnlta1gSVEXYDdI5sHNCBQRb-htadg",
        'username': map["username"],
      }, list);
    }
    notifyListeners();
  }

  Future userAdd(Map<String,String> map, List list) async{
    UserModel userModel = UserModel.fromJson(map);
    try {
      await dbHelper.collection("users").document(map["uid"]).setData(
        {
          'uid': userModel.uid,
          'description': "",
          //'email': userModel.,
          'photo': "https://lh3.googleusercontent.com/proxy/T6IeQuPpes7UTByNh0HkQfChkh29iCZOAx2Tpdw7dqIp_tXOsgMwJ5MBDTRd3sAp4KTkVOh4ewtHJKjqsHMVNX87GaXuPCk1YZpacrd1N_nWnrGTPALvo87vxVUrS-nWOnlta1gSVEXYDdI5sHNCBQRb-htadg",
          'username': userModel.username,
          'search': list
        }
      );
      
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    notifyListeners();
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
      email: email, password: password
      );
      FirebaseUser user = result.user;
      cuid = user.uid;
      await saveUid(user.uid);
      return true;
    } catch (e) {
      print("hata");
      return false;
    }
  }

  userUpdate(Map<String,dynamic> map){
    try {
      dbHelper.collection("users").document(cuid).updateData(map);
    } catch (e) {
      return e;
    }
    notifyListeners();
  }

  logOut(){
    notifyListeners();
    cuid ="";
    saveUid("");
  }

  saveUid(String uid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("cuid", uid);
  }

  loadUid()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String text = prefs.getString("uid");
    cuid = text;
    notifyListeners();
  }

  getProfile(String uid){
    notifyListeners();
    String id = (uid == null) ? cuid : uid;
    return dbHelper.collection("users").document(id).snapshots();

  }
}