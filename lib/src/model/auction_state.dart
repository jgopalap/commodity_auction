import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/product_repository.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class AuctionState extends Equatable {
  const AuctionState();

  @override
  List<Object> get props => [];
}

class AuctionInitial extends AuctionState {}

