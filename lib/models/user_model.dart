class UserModel {
  String id;
  String email;
  String token;
  String username;
  bool emailVerified;

  UserModel(
      {this.id, this.email, this.token, this.username, this.emailVerified});

  String get usersname => username;

  // Map setUser(UserModel user) {
  //   var data = Map<String, dynamic>();
  //   data["_id"] = user.id;
  //   data["token"] = user.token;
  //   data["username"] = user.username;
  //   data["email"] = user.email;
  //   data["emailVerified"] = user.emailVerified;
  //   return data;
  // }

  factory UserModel.getUser({Map<String, dynamic> mapData}) {
    mapData = mapData ?? {};
    return UserModel(
      token: mapData['token'] ?? '',
      username: mapData['user']['username'] ?? '',
      email: mapData['user']['email'] ?? '',
      emailVerified: mapData['user']['emailVerified'],
    );

    
  }

  @override
    String toString() {
      return 'Student: {name: $token}';
    }
}
