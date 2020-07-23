import 'package:ceylonteaauction/src/bloc/auction_list_bloc.dart';
import 'package:ceylonteaauction/src/bloc/authentication_bloc.dart';
import 'package:ceylonteaauction/src/bloc/bid_bloc.dart';
import 'package:ceylonteaauction/src/event/authentication_event.dart';
import 'package:ceylonteaauction/src/model/authentication_state.dart';
import 'package:ceylonteaauction/src/ui/auction_screen/auction_list_view.dart';
import 'package:ceylonteaauction/src/ui/login/login_indicator.dart';
import 'package:ceylonteaauction/src/ui/login/login_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../splash_screen.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text('Mombasa Tea Auction', style: Theme.of(context).textTheme.headline6),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider (
                  create: (context) => AuthenticationBloc()..add(AppStarted())
              ),
              BlocProvider (
                  create: (context) => AuctionListBloc()
              )
            ],
            child: App()
        )
    );
  }
}

class App extends StatelessWidget {

  App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is AuthenticationAuthenticated) {
            return AuctionListView();
          }
          if (state is AuthenticationUnauthenticated) {
            return LoginScreen();
          }
          if (state is AuthenticationLoading) {
            return LoadingIndicator();
          }
          return SplashPage();
        },
      );
  }
}