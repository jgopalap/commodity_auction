import 'package:bloc/bloc.dart';
import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/model/bid_state.dart';
import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/auction_repository.dart';

class BidBloc extends Bloc<AuctionEvent, BidState> {

  @override
  get initialState => BidInitial();

  @override
  Stream<BidState> mapEventToState(AuctionEvent event) async* {
    if (event is SubmitBidButtonPressed) {
      Auction auction = AuctionRepository().auctions[event.auctionId];
      bool success = await auction.submitBid(event.value,
      event.weight, event.budget, event.bidId);

      if (success) {
        yield BidSubmitted();
      } else {
        yield BidSubmitFailed();
      }
    }

    yield BidInitial();
  }

}