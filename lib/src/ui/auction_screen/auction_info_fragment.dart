import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/product_repository.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuctionInfoFragment extends StatelessWidget {

  final Auction auction;
  final User user;
  final Product product;
  final ProductCategory category;

  const AuctionInfoFragment({Key key, this.auction, this.user, this.product,
                             this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Container (
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),

      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.fromBorderSide(
          BorderSide(
            width: 5,
          )
        )
      ),
      child: FittedBox(
                  alignment: Alignment.center,
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Lot No. ' + auction.lotId.toString()),
                      Text(category.subcategory),
                      Text(user.info.businessName),
                      Text('US\$ ' + auction.reservePrice.toString() + ' /kg'),
                      Text(auction.offeredWeight.toString() + ' kg'),
                      Text(auction.getStateText()),
                      Text(category.subcategory),
                      Text(user.info.username)
                    ]
                  ))
      );
  }

}