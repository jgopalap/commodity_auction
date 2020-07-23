import 'dart:convert';
import 'package:ceylonteaauction/src/util/network_util.dart';
import 'auction.dart';
import 'http_status.dart';

class AuctionRepository {
    Map<int, Auction> auctions = new Map();

    static final AuctionRepository _instance = AuctionRepository._internal();

    factory AuctionRepository() {
      return _instance;
    }

    AuctionRepository._internal();

    Future<void> init() async {
        final response = await NetworkUtils.getRequest('getAuctions');
        Map<String, dynamic> jsonMap = json.decode(response.body);
        HttpStatus status = HttpStatus.fromJson(jsonMap);
        if (status.status) {
          List<dynamic> auctionList = jsonMap['auctions'];
          for (var i = 0; i < auctionList.length; i++) {
            var auction = Auction.fromJson(auctionList[i]);
            auctions[auction.id] = auction;
          }
        }
    }
}





