import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';


abstract class AuctionEvent extends Equatable {
  const AuctionEvent();

  @override
  List<Object> get props => [];
}

class InitializeAuctionList extends AuctionEvent {}

class AuctionViewNavigateBack extends AuctionEvent {}

class AuctionItemTapped extends AuctionEvent {
  final int id;

  const AuctionItemTapped({
    @required this.id,
  });

  @override
  List<Object> get props => [id];

  @override
  String toString() =>
      'AuctionItemTapped { id: $id }';
}

class SubmitBidButtonPressed extends AuctionEvent {
  final int auctionId;
  final double value;
  final double weight;
  final double budget;
  final int bidId;

  const SubmitBidButtonPressed({
    @required this.auctionId,
    @required this.value,
    @required this.weight,
    @required this.budget,
    @required this.bidId
  });

  @override
  List<Object> get props => [auctionId, value, weight, budget, bidId];

  @override
  String toString() =>
      'AuctionItemTapped { auction id: $auctionId , '
          'value: $value, weight: $weight, budget: $budget , update: $bidId}';
}