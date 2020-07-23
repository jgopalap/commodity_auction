import 'dart:convert';

import 'package:ceylonteaauction/src/model/repository/http_status.dart';
import 'package:ceylonteaauction/src/util/network_util.dart';

class LotRepository {
  Map<int, Lot> lots = new Map();
  static final LotRepository _instance = LotRepository._internal();

  factory LotRepository() {
    return _instance;
  }

  LotRepository._internal();

  Future<Lot> get(int id) async {
    if (lots.containsKey(id)) {
      return lots[id];
    }
    final response = await NetworkUtils.getRequest('getLot?lot_id=' +
        id.toString());

    HttpStatus status = HttpStatus.fromJson(json.decode(response.body));
    if (status.status) {
      Lot lot = Lot.fromJson(json.decode(response.body));
      lots[lot.lotId] = lot;
      return lot;
    }
    return Future.error('Unable to retrieve lot.');
  }
}


class Lot {
  int lotId;
  int productId;
  double originalWeight;
  int awrNo;
  int gardenReportNo;
  DateTime dateArrived;
  double remainingWeight;

  Lot({this.lotId, this.productId, this.originalWeight, this.awrNo,
    this.gardenReportNo, this.dateArrived, this.remainingWeight});

  factory Lot.fromJson(Map<String, dynamic> json) {
    return Lot(
        lotId: json['lot']['lot_id'],
        productId: json['lot']['product_id'],
        originalWeight: json['lot']['original_weight'].toDouble(),
        awrNo: json['lot']['awr_no'],
        gardenReportNo: json['lot']['garden_report_no'],
        dateArrived: DateTime.parse(json['lot']['date_arrived']),
        remainingWeight: json['lot']['remaining_weight'].toDouble()
    );
  }

}