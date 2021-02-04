class AuthModel{
  String username;
  String email;
  String password;
  String uid;

  AuthModel({this.username, this.email, this.password, this.uid});


    AuthModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        password = json['password'],
        username = json['username'],
        uid = json['uid'];

    Map<String, dynamic> toJson() =>
    {
      'email': email,
      'password': password,
      "username":username,
      'uid': uid
    };

}