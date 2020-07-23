import 'package:ceylonteaauction/src/model/repository/bid.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BidListView extends StatelessWidget {
  final List<Bid> bids;

  BidListView({Key key, this.bids})
      :super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(children: toListItem(bids));
  }

  List<BidListItem> toListItem(List<Bid> bids) {
    List<BidListItem> items = new List();
    for (var i = 0; i < bids.length; i++) {
      items.add(BidListItem(bid: bids[i]));
    }

    return items;
  }
}

class BidListItem extends StatelessWidget {

  final Bid bid;

  const BidListItem({Key key, this.bid}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    User buyer = UserRepository().users[bid.buyerId];
    String subtitle = 'value: ' + bid.currency + bid.value.toString() + ' /kg'
                    + ' quantity: ' + bid.weight.toString() + 'kg'
                    + ' budget: ' + bid.currency + bid.budget.toString()
                    + (bid.isWinningBid ? ' winning bid' : '');
    return _tile(context, buyer.info.businessName, subtitle);
  }

  ListTile _tile(BuildContext context, String title, String subtitle) => ListTile(
      isThreeLine: true,
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle)
  );
}