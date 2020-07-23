import 'dart:convert';

import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:ceylonteaauction/src/util/network_util.dart';

import 'bid.dart';
import 'http_status.dart';

class Auction {
  int id;
  int locationId;
  int stateId;
  double soldPrice;
  double soldWeight;
  int sellerId;
  int lotId;
  double reservePrice;
  DateTime startTime;
  double offeredWeight;
  Map<int, Bid> bids = Map();

  Auction({this.id, this.locationId, this.stateId, this.soldPrice,
    this.soldWeight, this.sellerId, this.lotId, this.reservePrice,
    this.startTime, this.offeredWeight});

  factory Auction.fromJson(Map<String, dynamic> json) {
    return Auction(
        id: json['auction_id'],
        locationId: json['location_id'],
        stateId: json['state_id'],
        soldPrice: json['sold_price'].toDouble(),
        soldWeight: json['sold_weight'].toDouble(),
        sellerId: json['user_id'],
        lotId: json['lot_id'],
        reservePrice: json['reserve_price'],
        startTime: DateTime.parse(json['start_time']),
        offeredWeight: json['offered_weight'].toDouble()
    );
  }

  Future<void> init() async {
    final response = await NetworkUtils.getRequest(
        'getBidsForAuction?auction_id=' + id.toString());
    Map<String, dynamic> jsonMap = json.decode(response.body);
    HttpStatus status = HttpStatus.fromJson(jsonMap);
    if (status.status) {
      UserRepository userRepo = UserRepository();
      List<dynamic> storedBids = jsonMap['bids'];
      for (var i = 0; i < storedBids.length; i++) {
        Bid bid = Bid.fromJson(storedBids[i]);
        userRepo.getUser(bid.buyerId);
        bids[bid.id] = bid;
      }
    }
  }

  Future<bool> submitBid(double value, double weight,
      double budget, int bidId) async {
    DateTime time = DateTime.now().toUtc();
    Map<String, dynamic> body = new Map();
    body['value'] = value;
    body['weight'] = weight;
    body['budget'] = budget;
    body['auction_id'] = id;
    body['user_id'] = UserRepository().currentUser.info.id;
    body['time'] = time.toIso8601String();
    body['user_type_id'] = UserType.Buyer.index;

    if (bids.containsKey(bidId)) {
      body['bid_id'] = bidId;
      final response = await NetworkUtils.putRequest('updateBid',
          json.encode(body));
      HttpStatus status = HttpStatus.fromJson(json.decode(response.body));
      if (status.status) {
        Bid bid = bids[bidId];
        bid.value = value;
        bid.weight = weight;
        bid.budget = budget;
        bid.time = time;
        bids[bidId] = bid;
        Buyer buyer = UserRepository().currentUser;
        if (buyer.bids.containsKey(id)) {
          buyer.bids[id] = bid;
        }
      }
      return status.status;
    } else {
      final response = await NetworkUtils.postRequest('addBid',
          json.encode(body));
      Map<String, dynamic> jsonMap = json.decode(response.body);
      HttpStatus status = HttpStatus.fromJson(jsonMap);
      if (status.status) {
        Bid bid = Bid.fromJson(jsonMap['bid']);
        bids[bid.id] = bid;
        Buyer buyer = UserRepository().currentUser;
        if (buyer.bids.containsKey(id)) {
          buyer.bids[id] = bid;
        }
      }
      return status.status;
    }
  }

  AuctionStateType getState () {
    switch(stateId) {
      case 1:
        return AuctionStateType.Open;
      case 2:
        return AuctionStateType.Clearing;
      case 3:
        return AuctionStateType.Closed;
      default:
        return AuctionStateType.None;
    }
  }

  String getStateText() {
    switch(stateId) {
      case 1:
        return "Accepting Bids";
      case 2:
        return "Clearing Bids";
      case 3:
        return "Closed";
      default:
        return "Inactive";
    }
  }
}

enum AuctionType {
  single_buyer_open_bid_ascending,
  single_buyer_open_bid_ascending_walkout
}

enum AuctionStateType {
  None,
  Open,
  Clearing,
  Closed
}