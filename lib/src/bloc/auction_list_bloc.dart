import 'package:bloc/bloc.dart';
import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/model/auction_list_state.dart';
import 'package:ceylonteaauction/src/model/repository/auction.dart';
import 'package:ceylonteaauction/src/model/repository/auction_repository.dart';
import 'package:ceylonteaauction/src/model/repository/lot_repository.dart';
import 'package:ceylonteaauction/src/model/repository/product_repository.dart';
import 'package:ceylonteaauction/src/model/repository/user.dart';
import 'package:ceylonteaauction/src/model/repository/user_repository.dart';

class AuctionListBloc extends Bloc<AuctionEvent, AuctionListState> {
  final AuctionRepository auctionRepo = AuctionRepository();
  final ProductRepository productRepo = ProductRepository();
  final UserRepository userRepo = UserRepository();
  final LotRepository lotRepo = LotRepository();
  
  AuctionListBloc();

  @override
  get initialState => AuctionListInitial();

  @override
  Stream<AuctionListState> mapEventToState(AuctionEvent event) async* {
    if (event is InitializeAuctionList) {
      await auctionRepo.init();
      await productRepo.init();
      if (auctionRepo.auctions.isEmpty) {
        yield AuctionListEmpty();
      } else {
        yield AuctionListLaunched(
            auctions: auctionRepo.auctions.values.toList()
        );
      }
      return;
    } else if (event is AuctionViewNavigateBack) {
      yield AuctionListLaunched(
          auctions: auctionRepo.auctions.values.toList()
      );
      return;
    } else if (event is AuctionItemTapped) {
      Auction auction = auctionRepo.auctions[event.id];
      auction.init();

      User user = await userRepo.getUser(auction.sellerId);
      Lot lot = await lotRepo.get(auction.lotId);
      Product product = await productRepo.getProduct(lot.productId);
      ProductCategory category =
      productRepo.getProductCategory(product.categoryId);

      yield AuctionListItemLaunched(
          auction: auction, seller: user, product: product,
          category: category);
      return;
    }

    yield AuctionListInitial();
  }
}