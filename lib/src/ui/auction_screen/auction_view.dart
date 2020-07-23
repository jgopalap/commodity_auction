import 'package:ceylonteaauction/src/bloc/auction_list_bloc.dart';
import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/bid.dart';
import 'package:ceylonteaauction/src/model/repository/product_repository.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';
import 'package:ceylonteaauction/src/ui/auction_screen/bid_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auction_info_fragment.dart';
import 'bid_view.dart';

class AuctionView extends StatelessWidget {
  final Auction auction;
  final User seller;
  final Product product;
  final ProductCategory category;


  const AuctionView({Key key, this.auction, this.seller, this.product, this.category}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
      return Scaffold(
          appBar:AppBar(
            title: Text("Auction No. " + auction.id.toString(),
                style: Theme.of(context).textTheme.headline6),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                BlocProvider.of<AuctionListBloc>(context).add(AuctionViewNavigateBack());
                Navigator.pop(context);
              }
            )
          ),
          body: Column(
              children: toList(() sync* {
                yield Flexible(child: AuctionInfoFragment(auction: auction,
                    user: seller, product: product, category: category));
                final User user = UserRepository().currentUser;
                final auctionId = auction.id;
                Widget buttonText;
                if (user is Buyer) {
                  if (user.bids.containsKey(auctionId)) {
                    buttonText = Text('Update Bid');
                  } else {
                    buttonText = Text('Place Bid');
                  }
                } else {
                  buttonText = Text('View Bids');
                }
                  yield Center(
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(
                            builder: (context) {
                              final user = UserRepository().currentUser;
                              //Widget
                              if (user is Buyer) {
                                Bid bid;
                                if (user.bids.containsKey(auctionId)) {
                                  bid = user.bids[auctionId];
                                }
                                return BidView(buyerId: user.info.id,
                                    auctionId: auctionId, bid:bid);
                              } else {
                                return BidListView(bids:
                                auction.bids.values.toList());
                              }
                            }
                            ));
                      },
                      color: Colors.black,
                      textColor: Colors.white,
                      child: buttonText
                    )
                  );
              }
              )
          )
      );

  }
}

typedef Iterable<T> IterableCallback<T>();

List<T> toList<T>(IterableCallback<T> cb) {
  return List.unmodifiable(cb());
}