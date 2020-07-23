class Bid {
  int id;
  int buyerId;
  double value;
  double weight;
  DateTime time;
  double budget;
  int auctionId;
  String currency;
  bool isWinningBid;

  Bid({this.id, this.buyerId, this.value, this.weight, this.time, this.budget,
    this.auctionId, this.currency, this.isWinningBid});

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
        id: json['bid_id'],
        buyerId: json['user_id'],
        value: json['value'].toDouble(),
        weight: json['weight'].toDouble(),
        time: DateTime.parse(json['time']),
        budget: json['budget'].toDouble(),
        auctionId: json['auction_id'],
        currency: json['currency'],
        isWinningBid: json['is_winning_bid']);
  }
}