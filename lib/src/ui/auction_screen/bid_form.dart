import 'package:ceylonteaauction/src/bloc/auction_list_bloc.dart';
import 'package:ceylonteaauction/src/bloc/bid_bloc.dart';
import 'package:ceylonteaauction/src/event/auction_event.dart';
import 'package:ceylonteaauction/src/model/repository/bid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BidForm extends StatefulWidget {
  final int buyerId;
  final int auctionId;
  final Bid bid;

  BidForm({this.buyerId, this.auctionId, this.bid});

  BidFormState createState() => BidFormState(buyerId: buyerId,
    auctionId: auctionId, bid: bid);
}

// Create a corresponding State class.
// This class holds data related to the form.
class BidFormState extends State<BidForm> {
  final int buyerId;
  final int auctionId;
  final Bid bid;

  BidFormState({this.buyerId, this.auctionId, this.bid});

  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a GlobalKey<FormState>,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final valueController =
    TextEditingController(text:bid==null?'':bid.value.toString());
    final quantityController =
    TextEditingController(text:bid==null?'':bid.weight.toString());
    final budgetController =
    TextEditingController(text:bid==null?'':bid.budget.toString());
    return Form(
            key: _formKey,
            child: Container (
                width: double.infinity,
                margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
                padding: EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.fromBorderSide(
                        BorderSide(width: 5)
                    )
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: valueController,
                        keyboardType: TextInputType.numberWithOptions(signed: false,
                            decimal: true),
                        inputFormatters: [WhitelistingTextInputFormatter(
                            RegExp(r'^[0-9]+\.?[0-9]?[0-9]?$'))],
                        decoration: InputDecoration(hintText: 'Value of lot in USD/kg'),
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter the bid value.';
                          }
                          return null;
                        }
                      ),
                    TextFormField(
                      controller: quantityController,
                      keyboardType: TextInputType.numberWithOptions(signed: false,
                          decimal: true),
                      inputFormatters: [WhitelistingTextInputFormatter(
                          RegExp(r'^[0-9]+\.?[0-9]?[0-9]?$'))],
                      decoration: InputDecoration(hintText: 'Desired quantity in kg'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter the quantity.';
                        }
                        return null;
                      }
                    ),
                    TextFormField(
                      controller: budgetController,
                      keyboardType: TextInputType.numberWithOptions(signed: false,
                          decimal: true),
                      inputFormatters: [WhitelistingTextInputFormatter(
                          RegExp(r'^[0-9]+\.?[0-9]?[0-9]?$'))],
                      decoration: InputDecoration(hintText: 'Budget for spend on this auction'),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your budget in USD.';
                        }
                        return null;
                      },
                    ),
                    Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton(
                              color: Colors.black,
                              textColor: Colors.white,
                              onPressed: () {
                                // Validate returns true if the form is valid,
                                // or false otherwise.
                                if (_formKey.currentState.validate()) {
                                  // If the form is valid, display a Snackbar.
                                  Scaffold.of(context).showSnackBar(SnackBar(content:
                                  Text('Processing Data')));
                                  BlocProvider.of<BidBloc>(context).add(
                                      SubmitBidButtonPressed(auctionId: auctionId,
                                          value: double.parse(valueController.text),
                                          weight: double.parse(quantityController.text),
                                          budget: double.parse(budgetController.text),
                                          bidId: bid != null ? bid.id : -1));
                                }
                              },
                              child: Text('Submit')
                          )
                        )
                    )
                  ]
                )
            )
        );
  }
}