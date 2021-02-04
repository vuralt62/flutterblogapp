import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fular_blog_app/model/users_model.dart';
import 'package:fular_blog_app/services/authentication_service.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserService extends ChangeNotifier{
  var dbHelper = Firestore.instance;
  UserModel users;
  AuthenticationService authenticationService;
  final picker = ImagePicker();
  File image;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 75, maxHeight: 720, maxWidth: 1280);
    File _imageFile;
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      return _imageFile;
    }
  }

  Future<void> cropImage(CropAspectRatio aspectRatio, CropStyle cropStyle) async {
    File _imageFile = await getImage();
    if (_imageFile != null) {
      File cropped = await ImageCropper.cropImage(
      cropStyle: cropStyle,
      aspectRatio: aspectRatio,
      sourcePath: _imageFile.path,
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true),
      );
      setImage(cropped);
    }
    notifyListeners();
  }

  setImage(File _imageFile){
    image = _imageFile;
    notifyListeners();
  }

  clearImage(){
    image=null;
    notifyListeners();
  }

  uploadImage(String folder, File _image)async{
    DateTime dateTime = DateTime.now();
    final StorageReference storageReference = FirebaseStorage.instance.ref().child(cuid).child(folder);
    final StorageUploadTask task = storageReference.child(dateTime.toString()+".jpg").putFile(_image);
    var url = (await task.onComplete).ref.getDownloadURL();
    clearImage();
    return url;
  }

  getProfile(String uid){
    notifyListeners();
    return dbHelper.collection("users").document(uid).get();
  }
}


