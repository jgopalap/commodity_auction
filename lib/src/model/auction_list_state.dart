import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/product_repository.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuctionListState extends Equatable {
  const AuctionListState();

  @override
  List<Object> get props => [];
}

class AuctionListInitial extends AuctionListState {}

class AuctionListLaunched extends AuctionListState {
  final List<Auction> auctions;

  const AuctionListLaunched({@required this.auctions});
}

class AuctionListEmpty extends AuctionListState {
  const AuctionListEmpty();
}

class AuctionListItemLaunched extends AuctionListState {
  final Auction auction;
  final User seller;
  final Product product;
  final ProductCategory category;

  const AuctionListItemLaunched({@required this.auction, @required this.seller,
    @required this.product, @required this.category});

  @override
  List<Object> get props => [auction, seller, product, category];

}