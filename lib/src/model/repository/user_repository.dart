import 'package:ceylonteaauction/src/model/repository/http_status.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:ceylonteaauction/src/util/network_util.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

class UserRepository {

  Map<int, User> users = new Map();
  User currentUser;
  static final UserRepository _instance = UserRepository._internal();

  factory UserRepository() {
    return _instance;
  }

  UserRepository._internal();

  void init() async {
    currentUser.init();
    final response = await NetworkUtils.getRequest('getUsers');
    Map<String, dynamic> jsonMap = json.decode(response.body);
    HttpStatus status = HttpStatus.fromJson(jsonMap);
    if (status.status) {
      List<dynamic> userList = jsonMap['users'];
      for (var i = 0; i < userList.length; i++) {
        var user = fromJson(userList[i]);
        if (currentUser.info.id != user.info.id) {
          users[user.info.id] = user;
        }
      }
    }
  }

  Future<bool> authenticate({
    @required String username,
    @required String password,
  }) async {
    final response = await NetworkUtils.postRequest('login',
        jsonEncode(<String, String>{
          'username': username,
          'password': password
        }));

    Map<String, dynamic> jsonMap = json.decode(response.body);
    HttpStatus status = HttpStatus.fromJson(jsonMap);
    if (status.status) {
      User user = fromJson(jsonMap['user']);
      currentUser = user;
      init();
    }

    return status.status;
  }

  Future<User> getUser(int id) async {
    if (users.containsKey(id)) {
      return users[id];
    }
    final response = await NetworkUtils.getRequest('getUser?user_id=' +
        id.toString());

    Map<String, dynamic> jsonMap = json.decode(response.body);
    HttpStatus status = HttpStatus.fromJson(jsonMap);
    if (status.status) {
      User user = fromJson(jsonMap['user']);
      users[user.info.id] = user;
      return user;
    }
    return Future.error('Unable to retrieve user.');
  }

   User fromJson(Map<String, dynamic> json) {
    int userTypeId = json['user_type_id'];

    UserInfo info = UserInfo(id: json['user_id'],
        username: json['username'],
        password: json['password'],
        emailAddress: json['email_address'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        businessAddress: json['business_address'],
        businessName: json['business_name']);

    switch (UserType.values[userTypeId]) {
      case UserType.Admin:
        return Admin(info);
      case UserType.Broker:
        return Broker(info);
      case UserType.Buyer:
        return Buyer(info);
      case UserType.Producer:
        return Producer(info);
      default:
        return null;
    }
  }

}

