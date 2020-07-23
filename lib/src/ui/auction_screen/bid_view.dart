import 'package:ceylonteaauction/src/bloc/bid_bloc.dart';
import 'package:ceylonteaauction/src/model/bid_state.dart';
import 'package:ceylonteaauction/src/model/repository/bid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bid_form.dart';

class BidView extends StatelessWidget {
  final int buyerId;
  final int auctionId;
  final Bid bid;

  BidView({this.buyerId, this.auctionId, this.bid});

  @override
  Widget build(BuildContext context) {
    return BlocProvider (
        create: (context) => BidBloc(),
        child:Scaffold(
        appBar: AppBar(
          title: Text('Place Bid',
              style: Theme
                  .of(context)
                  .textTheme
                  .headline6),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: BlocListener<BidBloc, BidState>(
          listener: (context, state) {
              if (state is BidSubmitted) {
                Navigator.pop(context);
              } else {
              Scaffold.of(context)
                  .showSnackBar(SnackBar(content:
              Text('Submission Failed.')));
              }
            },
          child: BidForm(buyerId: buyerId, auctionId: auctionId, bid: bid)
      ))
    );
  }
}