import 'dart:convert';

import 'package:ceylonteaauction/src/util/network_util.dart';

import 'bid.dart';
import 'http_status.dart';

abstract class User {
  UserInfo info;
  UserPermission permission;

  User({this.info, this.permission});

  void init();
  int type();

}

class Buyer extends User {
  Map<int, Bid> bids = new Map();

  Buyer(info): super(info:info,
      permission: UserPermission(canCreateBids: true, canUpdateBids: true,
        canDeleteBids: true, ));

  void init() async {
    final getResponse = await NetworkUtils.getRequest(
        'getBidsForUser?user_id=' + info.id.toString());
    Map<String, dynamic> jsonMap = json.decode(getResponse.body);
    HttpStatus status = HttpStatus.fromJson(jsonMap);
    if (status.status) {
      fromJsonToBids(jsonMap);
    }
  }

  void fromJsonToBids(Map<String, dynamic> json) {
    List<dynamic> storedBids = json['bids'];
    for (var i = 0; i < storedBids.length; i++) {
      var bid = Bid.fromJson(storedBids[i]);
      if (!bids.containsKey(bid.auctionId)) {
        bids[bid.auctionId] = bid;
      }
    }
  }

  int type() {
    return 3;
  }
}

class Admin extends User {
  Admin(info): super(info:info, permission: UserPermission(canReadUsers: true, canAuthorizeUsers: true,
      canReadOrders: true));

  int type() {
    return 1;
  }

  void init() {}
}

class Producer extends User {
  Producer(info):
        super(info:info, permission: UserPermission(canCreateAuctions: true,
          canUpdateAuctions: true, canDeleteAuctions: true, canRunAuctions: true));

  void init() {}
  int type() {
    return 4;
  }
}

class Broker extends User {
  Broker(info):
        super(info:info,
          permission: UserPermission(canCreateAuctions: true,
              canUpdateAuctions: true, canDeleteAuctions: true,
              canRunAuctions: true, canReadBids: true, canReadUsers: true,
              canReadOrders: true, canUpdateOrders: true, canDeleteOrders: true));

  int type() {
    return 2;
  }

  void init() {}
}

class UserPermission {
  bool canReadAuctions = true;
  bool canCreateAuctions;
  bool canUpdateAuctions;
  bool canDeleteAuctions;
  bool canRunAuctions;

  bool canReadBids;
  bool canCreateBids;
  bool canUpdateBids;
  bool canDeleteBids;

  bool canReadUsers;
  bool canAuthorizeUsers;

  bool canReadOrders;
  bool canUpdateOrders;
  bool canDeleteOrders;
  bool canCreateOrders = false;

  UserPermission({this.canReadAuctions, this.canCreateAuctions,
    this.canUpdateAuctions, this.canDeleteAuctions, this.canRunAuctions,
    this.canReadBids, this.canCreateBids, this.canUpdateBids, this.canDeleteBids,
    this.canReadUsers, this.canAuthorizeUsers, this.canReadOrders,
    this.canUpdateOrders, this.canDeleteOrders, this.canCreateOrders});
}

enum UserType {
  None,
  Admin,
  Broker,
  Buyer,
  Producer
}

class UserInfo {
  int id;
  String username;
  String password;
  String emailAddress;
  String firstName;
  String lastName;
  String businessAddress;
  String businessName;

  UserInfo({this.id, this.username, this.password, this.emailAddress,
    this.firstName, this.lastName, this.businessAddress, this.businessName});

}

