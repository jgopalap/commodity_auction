import 'package:ceylonteaauction/src/bloc/auction_list_bloc.dart';
import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/model/auction_list_state.dart';
import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/ui/auction_screen/auction_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuctionListView extends StatelessWidget {

  AuctionListView({Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Auctions')),
        body: AuctionList()
    );
  }

}

class AuctionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuctionListBloc, AuctionListState>(
        listener: (context, state) {
          if (state is AuctionListItemLaunched) {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (_) =>
                    BlocProvider.value(
                        value: BlocProvider.of<AuctionListBloc>(
                            context),
                        child: AuctionView(auction: state.auction,
                            seller: state.seller, product: state.product,
                            category: state.category)
                    )
                )
            );
          }
        },
        child: BlocBuilder<AuctionListBloc, AuctionListState>(
            builder: (context, state) {
              if (state is AuctionListLaunched) {
                return ListView(children: toListItem(state.auctions));
              } else if (state is AuctionListEmpty) {
                return Center(
                    child: Text('Auctions don\'t exist yet, but please do '
                        'check back again soon.'));
              }
              return Container();
            })
    );
  }

  List<AuctionListItem> toListItem(List<Auction> auctions) {
    List<AuctionListItem> items = new List();
    for (var i = 0; i < auctions.length; i++) {
      items.add(AuctionListItem(auction: auctions[i]));
    }

    return items;
  }
}

class AuctionListItem extends StatelessWidget {

  final Auction auction;

  const AuctionListItem({Key key, this.auction}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    String subtitle;
    if (AuctionStateType.values[auction.stateId] == AuctionStateType.Open) {
      subtitle = auction.getStateText() + " until " + auction.startTime.toString();
    } else {
      subtitle = 'Auction is ' + auction.getStateText();
    }
    return _tile(context, "Auction No. " + auction.id.toString(), subtitle);
  }

  ListTile _tile(BuildContext context, String title, String subtitle) => ListTile(
      isThreeLine: true,
      title: Text(title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
          )),
      subtitle: Text(subtitle),
      onTap: () {
        BlocProvider.of<AuctionListBloc>(context).add(AuctionItemTapped(id: auction.id));
      }
  );
}