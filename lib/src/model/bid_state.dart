import 'package:ceylonteaauction/src/model/repository/bid.dart';
import 'package:equatable/equatable.dart';

abstract class BidState extends Equatable {
  const BidState();

  @override
  List<Object> get props => [];
}

class BidInitial extends BidState {}

class BidSubmitted extends BidState {
  final Bid bid;

  BidSubmitted({this.bid});

}

class BidSubmitFailed extends BidState {}